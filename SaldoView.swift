import Foundation
import SwiftUI
import CoreData

struct SaldoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    //  INCOME
    @FetchRequest(entity: Income.entity(), sortDescriptors: []) var incomes: FetchedResults<Income>
    
    //  EXPENSE
    @FetchRequest(entity: Expense.entity(), sortDescriptors: []) var expenses: FetchedResults<Expense>
    
    //  CATEGORY INCOME
    @FetchRequest(entity: CategoryIncome.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CategoryIncome.name, ascending: true)]) private var categoriesCoreDataI: FetchedResults<CategoryIncome>
    
    //  CATEGORY EXPENSE
    @FetchRequest(entity: CategoryExpense.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CategoryExpense.name, ascending: true)]) private var categoriesCoreDataE: FetchedResults<CategoryExpense>

    @State private var showDeleteConfirmation = false
    @State private var deleteIncomeOffsets = IndexSet()
    @State private var deleteExpenseOffsets = IndexSet()
    @State private var visibility: Bool = false
    
    //  SALDO
   
    var totalIncome: Decimal {
        incomes.reduce(Decimal(0)) { $0 + ($1.amount?.decimalValue ?? 0) }
    }

    var totalExpense: Decimal {
        expenses.reduce(Decimal(0)) { $0 + ($1.amount?.decimalValue ?? 0) }
    }

    var saldo: Decimal {
        totalIncome - totalExpense
    }

    var body: some View {
        VStack {
            Text("Saldo: \(saldo.description)")
                .font(.title)
            
            List {
                Section(header: Text("Przychody")) {
                    if incomes.isEmpty {
                        Text("Brak danych")
                    } else {
                        ForEach(Array(incomes.enumerated()), id: \.element) { (index, income) in
                            HStack {
                                Text("\(income.name ?? "")")
                                Text("\(income.amount ?? 0)")
                                if let categoryIncome = income.toCategoryIncome {
                                    Text("\(categoryIncome.name ?? "")")
                                } else {
                                    Text("Brak kategorii")
                                }
                            }
                        }
                        .onDelete { offsets in
                            deleteIncomeOffsets = offsets
                            showDeleteConfirmation = true
                        }
                        
                    
                    }
                }
                
                Section(header: Text("Wydatki")) {
                    if expenses.isEmpty {
                        Text("Brak danych")
                    } else {
                        ForEach(Array(expenses.enumerated()), id: \.element) { (index, expense) in
                            HStack {
                                Text("\(expense.name ?? "")")
                                Text("\(expense.amount ?? 0)")
                            }
                            
                        }
                        .onDelete { offsets in
                            deleteExpenseOffsets = offsets
                            showDeleteConfirmation = true
                        }


                    }
                }
            }
            .navigationTitle("Saldo")
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Usuwanie"),
                    message: Text("Czy na pewno chcesz usunąć te wpisy?"),
                    primaryButton: .destructive(Text("Usuń"), action: {
                        deleteTransactions()
                    }),
                    secondaryButton: .cancel(Text("Anuluj"))
                )
            }
        }
    }
    
    private func deleteTransactions() {
        withAnimation {
            deleteIncomeOffsets.forEach { index in
                if let incomeIndex = indexToIncomeIndex(index) {
                    let income = incomes[incomeIndex]
                    viewContext.delete(income)
                }
            }
            
            deleteExpenseOffsets.forEach { index in
                if let expenseIndex = indexToExpenseIndex(index) {
                    let expense = expenses[expenseIndex]
                    viewContext.delete(expense)
                }
            }
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            deleteIncomeOffsets = IndexSet() // Clear the delete offsets after successful deletion
            deleteExpenseOffsets = IndexSet()
        }
    }
    
    private func indexToIncomeIndex(_ index: Int) -> Int? {
        let incomeCount = incomes.count
        
        guard incomeCount > 0, index < incomeCount else {
            return nil
        }
        
        return index
    }
    
    
    private func indexToExpenseIndex(_ index: Int) -> Int? {
        let expenseCount = expenses.count
        
        guard expenseCount > 0, index < expenseCount else {
            return nil
        }
        
        return index
    }
}

struct SaldoView_Previews: PreviewProvider {
    static var previews: some View {
        SaldoView()
    }
}
