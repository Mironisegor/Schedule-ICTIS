import SwiftUI
import CoreData

struct ScheduleView: View {
    @ObservedObject var vm: ScheduleViewModel
    @ObservedObject var networkMonitor: NetworkMonitor
    @FetchRequest(fetchRequest: CoreDataClassModel.all()) var classes             // Список пар добавленных пользователем
    @FetchRequest(fetchRequest: JsonClassModel.all()) private var subjects        // Список пар сохраненных в CoreData(для отсутствия интернета)
    @FetchRequest(fetchRequest: FavouriteGroupModel.all()) private var favGroups
    @FetchRequest(fetchRequest: FavouriteVpkModel.all()) private var favVpk
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
    
    private var onlineContent: some View {
        Group {
            if vm.errorInNetwork == .timeout {
                NetworkErrorView(message: "Проверьте подключение к интернету")
            } else if vm.errorInNetwork == .invalidResponse {
                NoScheduleView()
            }
            else if vm.errorInNetwork == .noError {
                scheduleScrollView(isOnline: true)
            }
            else {
                NoScheduleView()
            }
        }
        .onAppear {
            if vm.classesGroups.isEmpty {
                vm.fetchWeekSchedule()
            }
        }
    }
    
    private var offlineContent: some View {
        scheduleScrollView(isOnline: false)
    }
    
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
                let filteredSubjects = subjects.filter {($0.day == Int16(vm.selectedIndex))}
                if (filteredSubjects.isEmpty || vm.week != 0) && !hasSubjectsToShow {
                    ConnectingToNetworkView()
                        .padding(.top, 100)
                } else {
                    ForEach(filteredSubjects, id: \.self) { subject in
                        if vm.showOnlyChoosenGroup == "Все" || subject.group == vm.showOnlyChoosenGroup {
                            SubjectView(info: ClassInfo(subject: subject.name, group: subject.group, time: subject.time), vm: vm)
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

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
