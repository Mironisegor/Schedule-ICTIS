import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            HStack (spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.gray)
                    .padding(.leading, 12)
                    .padding(.trailing, 7)
                TextField("Поиск группы", text: $text)
                    .disableAutocorrection(true)
                    .frame(width: .infinity, height: 40)
                    .onTapGesture {
                        self.isEditing = true
                    }
                    .onSubmit {
                        self.isEditing = false
                    }
                if isEditing {
                    Button {
                        self.text = ""
                        self.isEditing = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .padding(.trailing, 20)
                            .offset(x: 10)
                            .foregroundColor(.gray)
                            .background(
                                Rectangle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            )
                    }
                    .background(Color.white)
                }
                else {
                    Rectangle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            Spacer()
            Button {
                
            } label: {
                ZStack {
                    Rectangle()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color("blueColor"))
                        .cornerRadius(15)
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundStyle(.white)
                        .scaledToFit()
                        .frame(width: 16)
                }
            }
        }
        .frame(width: .infinity)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

#Preview {
    ScheduleView()
}
