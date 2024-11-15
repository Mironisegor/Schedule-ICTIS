import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.gray)
                    .padding(.leading, 10)
                TextField("Поиск группы", text: $text)
                    .disableAutocorrection(true)
                    .frame(width: 270, height: 45)
                    .overlay(
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
                                }
                                }
                        }, alignment: .trailing
                    )
                    .onTapGesture {
                        self.isEditing = true
                    }
                    .onSubmit {
                        self.isEditing = false
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
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color("blueColor"))
                        .cornerRadius(10)
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundStyle(.white)
                        .scaledToFit()
                        .frame(width: 16)
                    }
                }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ScheduleView()
}
