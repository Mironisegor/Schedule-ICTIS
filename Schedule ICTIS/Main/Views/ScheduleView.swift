import SwiftUI
import CoreData

struct ScheduleView: View {
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    @FetchRequest(fetchRequest: CoreDataClassModel.all()) private var classes  // Список пар добавленных пользователем
    @FetchRequest(fetchRequest: JsonClassModel.all()) private var subjects     // Список пар сохраненных в CoreData
    @State private var selectedClass: CoreDataClassModel? = nil
    @State private var lastOffset: CGFloat = 0
    @State private var scrollTimer: Timer? = nil
    @Binding var isScrolling: Bool
    var provider = ClassProvider.shared
    
    private var hasSubjectsToShow: Bool {
        subjects.contains { subject in
            subject.week == vm.week
        }
    }
    
    private var hasClassesToShow: Bool {
        classes.contains { _class in
            _class.day == vm.selectedDay
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if networkMonitor.isConnected {
                onlineContent
            } else {
                offlineContent
            }
            gradientOverlay
        }
        .onAppear {
            deleteClassesFormCoreDataIfMonday()
            if networkMonitor.isConnected {
                checkSavingOncePerDay()
            }
        }
        .sheet(item: $selectedClass, onDismiss: { selectedClass = nil }) { _class in
            CreateEditClassView(vm: .init(provider: provider, _class: _class), day: vm.selectedDay)
        }
    }
    
    // Онлайн-контент (с интернетом)
    private var onlineContent: some View {
        Group {
            if vm.errorInNetwork == .timeout {
                NetworkErrorView(message: "Проверьте подключение к интернету")
            } else if vm.isLoading {
                LoadingScheduleView()
            } else if vm.errorInNetwork != .invalidResponse {
                scheduleScrollView(isOnline: true)
            } else {
                NoScheduleView()
            }
        }
        .onAppear {
            if vm.classesGroups.isEmpty {
                vm.fetchWeekSchedule()
            }
        }
    }
    
    // Оффлайн-контент (без интернета)
    private var offlineContent: some View {
        scheduleScrollView(isOnline: false)
    }
    
    // Общий ScrollView для расписания
    private func scheduleScrollView(isOnline: Bool) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 30) {
                subjectsSection(isOnline: isOnline)
                myPairsSection
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.bottom, 100)
            .padding(.top, 10)
            .background(GeometryReader { geometry in
                Color.clear.preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).minY)
            })
        }
        .onPreferenceChange(ViewOffsetKey.self) { offset in
            if offset != lastOffset {
                isScrolling = true
                scrollTimer?.invalidate()
                scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                    isScrolling = false
                }
            }
            lastOffset = offset
        }
        .onDisappear {
            scrollTimer?.invalidate()
        }
    }
    
    // Секция с парами
    private func subjectsSection(isOnline: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if isOnline {
                ForEach(0..<vm.classesGroups.count, id: \.self) { dayIndex in
                    if dayIndex == vm.selectedIndex {
                        ForEach(vm.classesGroups[dayIndex]) { info in
                            if vm.showOnlyChoosenGroup == "Все" || info.group == vm.showOnlyChoosenGroup {
                                SubjectView(info: ClassInfo(subject: info.subject, group: info.group, time: info.time), vm: vm)
                            }
                        }
                    }
                }
            } else {
                let filteredSubjects = subjects.filter { $0.day == Int16(vm.selectedIndex) }
                if (filteredSubjects.isEmpty || vm.week != 0) && !hasClassesToShow {
                        ConnectingToNetworkView()
                        .padding(.top, 100)
                } else {
                    ForEach(filteredSubjects, id: \.self) { subject in
                        if (vm.showOnlyChoosenGroup == "Все" || subject.group == vm.showOnlyChoosenGroup) &&  vm.week == 0 {
                            SubjectView(info: ClassInfo(subject: subject.name!, group: subject.group!, time: subject.time!), vm: vm)
                        }
                    }
                }
            }
        }
    }
    
    // Секция "Мои пары"
    private var myPairsSection: some View {
        Group {
            if classes.contains(where: { daysAreEqual($0.day, vm.selectedDay) }) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Мои пары")
                        .font(.custom("Montserrat-Bold", fixedSize: 20))
                    ForEach(classes) { _class in
                        if daysAreEqual(_class.day, vm.selectedDay) {
                            CreatedClassView(_class: _class)
                                .onTapGesture {
                                    selectedClass = _class
                                }
                        }
                    }
                }
            }
        }
    }
    
    // Градиентный оверлей
    private var gradientOverlay: some View {
        VStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("background").opacity(0.95), Color.white.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .frame(width: UIScreen.main.bounds.width, height: 15)
    }
}

extension ScheduleView {
    private func deleteClassesFormCoreDataIfMonday() {
        let today = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: today)
        
        if weekday == 6 {
            for _class in classes {
                if _class.day < today {
                    do {
                        try provider.delete(_class, in: provider.viewContext)
                    } catch {
                        print("❌ - Ошибка при удалении: \(error)")
                    }
                }
            }
        }
    }
    
    func saveGroupsToMemory() {
        var indexOfTheDay: Int16 = 0
        let context = provider.newContext // Создаем новый контекст
        
        context.perform {
            for dayIndex in 0..<self.vm.classesGroups.count {
                let classesForDay = self.vm.classesGroups[dayIndex]
                
                // Проходим по всем занятиям текущего дня
                for classInfo in classesForDay {
                    let newClass = JsonClassModel(context: context)
                    
                    // Заполняем атрибуты
                    newClass.name = classInfo.subject
                    newClass.group = classInfo.group
                    newClass.time = classInfo.time
                    newClass.day = indexOfTheDay
                    newClass.week = Int16(vm.week)
                }
                indexOfTheDay += 1
            }
            
            // Сохраняем изменения в CoreData
            do {
                try self.provider.persist(in: context)
                print("✅ Успешно сохранено в CoreData")
            } catch {
                print("❌ Ошибка при сохранении в CoreData: \(error)")
            }
        }
    }
    
    @MainActor
    func deleteAllJsonClassModelsSync() throws {
        let context = provider.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = JsonClassModel.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try context.execute(deleteRequest)
        try context.save()
        print("✅ Все объекты JsonClassModel успешно удалены")
    }
    
    func checkSavingOncePerDay() {
        let today = Date()
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: today) // Начало текущего дня
        
        // Получаем дату последнего выполнения из UserDefaults
        let lastCheckDate = UserDefaults.standard.object(forKey: "LastSaving") as? Date ?? .distantPast
        let lastCheckStart = calendar.startOfDay(for: lastCheckDate)
    
        print("Дата последнего сохранения расписания в CoreData: \(lastCheckDate)")
        
        // Проверяем, был ли уже выполнен код сегодня
        if lastCheckStart < todayStart && networkMonitor.isConnected {
            print("✅ Интернет есть, сохранение пар в CoreData")
            vm.fillDictForVm()
            vm.fetchWeekSchedule()
            do {
                try deleteAllJsonClassModelsSync()
            } catch {
                print("Ошибка при удалении: \(error)")
                return
            }
            saveGroupsToMemory()
            
            // Сохраняем текущую дату как дату последнего выполнения
            UserDefaults.standard.set(today, forKey: "LastSaving")
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
