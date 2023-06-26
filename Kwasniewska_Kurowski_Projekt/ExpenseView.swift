
import SwiftUI
import CoreData

struct ExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Expense.entity(), sortDescriptors: []) private var expenses: FetchedResults<Expense>

    @FetchRequest(entity: CategoryExpense.entity(), sortDescriptors: []) private var categoriesCoreData: FetchedResults<CategoryExpense>

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var date: String = ""
    @State private var details: String = ""
    @State private var category: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    private let predefinedCategories = ["Bills", "Food", "Fun", "Sport"]
    
    @State private var selectedCategoryIndex = 0

    var body: some View {
        VStack {
            Text("Add expense:")
                .font(.largeTitle.bold())
                .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.6)) // Ciemny fiolet
                .padding(30)

            TextField("* Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title)
                .padding()

            TextField("* Amount", text: $amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title)
                .padding()

            Picker("Category", selection: $selectedCategoryIndex) {
                ForEach(0..<predefinedCategories.count, id: \.self) { index in
                    Text(predefinedCategories[index])
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .frame(width: 360)
            .background(Color(red: 0.8, green: 0.6, blue: 0.9)) // Jasny fiolet
            .cornerRadius(10)
            .padding()

            TextField("* Date", text: $date)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title)
                .padding()

            TextField("Details", text: $details)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title)
                .padding()

            Spacer()

            Button(action: {
                if name.isEmpty || amount.isEmpty || date.isEmpty {
                    showAlert = true
                    alertMessage = "Please fill in all required fields."
                } else if !isValidDateFormat(date) {
                    showAlert = true
                    alertMessage = "Please enter the date in the format dd-mm-yyyy."
                } else if !isValidAmount(amount) {
                    showAlert = true
                    alertMessage = "Please enter a valid amount of money with a dot, not comma."
                } else {
                    showAlert = false
                    alertMessage = ""

                    if let amountValue = Decimal(string: amount), let dateValue = convertToDate(date) {
                        let newExpense = Expense(context: viewContext)
                        newExpense.name = name
                        newExpense.amount = NSDecimalNumber(decimal: amountValue)
                        newExpense.date = dateValue
                        newExpense.details = details

                        let selectedCategory = CategoryExpense(context: viewContext)
                        selectedCategory.name = predefinedCategories[selectedCategoryIndex]
                        newExpense.toCategoryExpense = selectedCategory

                        do {
                            try viewContext.save()

                            showAlert = false
                            alertMessage = ""

                            // Resetowanie pól formularza po zapisaniu wydatku
                            name = ""
                            amount = ""
                            date = ""
                            details = ""
                        } catch {
                            print("Failed to save expense: \(error)")
                        }
                    } else {
                        showAlert = true
                        alertMessage = "Please enter valid values for amount and date."
                    }
                }
            }) {
                Text("Send")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color(red: 0.4, green: 0.2, blue: 0.6)) // Ciemny fiolet
                    .cornerRadius(10)
                    .padding()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Missing Fields"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
    }

    func isValidDateFormat(_ date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: date) != nil
    }

    func isValidAmount(_ amount: String) -> Bool {
        return Double(amount) != nil
    }

    private func convertToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: dateString)
    }
}

struct Previews_ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView()
    }
}
