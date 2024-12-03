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
                    .onTapGesture {
                        self.isEditing = true
                    }
                    .onSubmit {
                        self.isEditing = false
                    }
                ZStack {
                    Rectangle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        Group {
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
                                        )
                                }
                                .background(Color.white)
                            }
                        }
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
                        .frame(width: 40)
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
        .padding(.horizontal)
        .padding(.top, 5)
        .frame(height: 40)
    }
}

#Preview {
    ScheduleView()
}
