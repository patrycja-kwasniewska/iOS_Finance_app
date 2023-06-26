//
//  ContentView.swift
//  financeApp_CoreData
//
//  Created by Patrycja Kwaśniewska on 04/06/2023.
//

import SwiftUI
import CoreData
import Charts


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    //  INCOME
    @FetchRequest(entity: Income.entity(), sortDescriptors: []) var incomes: FetchedResults<Income>
    
    //  EXPENSE
    @FetchRequest(entity: Expense.entity(), sortDescriptors: []) var expenses: FetchedResults<Expense>
    
    
    
    //  CATEGORY INCOME
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryIncome.name, ascending: true)], animation: .default)
    private var categoryIncomes: FetchedResults<CategoryIncome>
    
    //  CATEGORY EXPENSE
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryExpense.name, ascending: true)], animation: .default)
    private var categoryExpense: FetchedResults<CategoryExpense>
    
    
    var totalIncome: Decimal {
        incomes.reduce(Decimal(0)) { $0 + ($1.amount?.decimalValue ?? 0) }
    }

    var totalExpense: Decimal {
        expenses.reduce(Decimal(0)) { $0 + ($1.amount?.decimalValue ?? 0) }
    }

    var saldo: Decimal {
        totalIncome - totalExpense
    }
    
    
    @State private var isCreateUserViewPresented = false
    @State private var chartItems: [ChartItem] = []
    @State private var changeColor = false



    var body: some View {
        mainContentView
        // ...
    }


    
    private var mainContentView: some View {
        let chartItems: [ChartItem] = [
               ChartItem(type: "Total Income", value: Double(truncating: totalIncome as NSNumber)),
               ChartItem(type: "Total Expense", value: NSDecimalNumber(decimal: totalExpense).doubleValue)
           ]
        
        return NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: SaldoView()) {
                        VStack {
                            Text("Saldo: \(saldo.description)")
                                .font(.title)
                                .foregroundColor(.black)
                                .frame(width: 150, height: 80)
                                .background(Color(red: 0.8, green: 0.6, blue: 0.9)) // Jasny fiolet
                                .cornerRadius(10)
                                .padding(20)
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: Profile()) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 45)) // Powiększanie ikonki
                            .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.6)) // Ciemny fiolet
                            .padding(30)
                    }
                    
                    
                }
                
                Spacer()
                
                VStack {
                    Text("FlameFunds")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(changeColor ? .red : .black)
                        .onLongPressGesture(minimumDuration: 1) {
                            changeColor.toggle()
                        }
                    
                    Chart(chartItems) { item in
                        BarMark(x: .value("Total income", item.type), y: .value("Total expense", item.value))
                    }
                    .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.6)) // Ciemny fiolet
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.9, green: 0.7, blue: 1.0),
                                Color(red: 0.8, green: 0.6, blue: 0.9)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(maxHeight: 500)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                }


                Spacer()
                
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: IncomeView()) {
                        Text("+")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .frame(width: 110, height: 80)
                            .background(Color(red: 0.4, green: 0.2, blue: 0.6)) // Ciemny fiolet
                            .cornerRadius(10)
                    }
                    .onAppear() {
                        if categoryIncomes.count == 0 {
                            addCategoryIncome()
                        }
                        viewContext.refreshAllObjects()
                    }
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: ExpenseView()) {
                        Text("-")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .frame(width: 110, height: 80)
                            .background(Color(red: 0.8, green: 0.6, blue: 0.9)) // Jasny fiolet
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                Spacer()
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    private func addCategoryIncome() {
        var newCategory = CategoryIncome(context: viewContext)
        newCategory.name = "Wypłata"
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        newCategory = CategoryIncome(context: viewContext)
        newCategory.name = "Premia"
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        newCategory = CategoryIncome(context: viewContext)
        newCategory.name = "Prezent"
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    //    // USUWANIE WSZYSTKICH DANYCH
    //    private func deleteAllData() {
    //        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CategoryIncome")
    //        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    //
    //        do {
    //            try viewContext.execute(deleteRequest)
    //            try viewContext.save()
    //        } catch {
    //            print("Błąd podczas usuwania danych: \(error.localizedDescription)")
    //        }
    //    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ChartItem: Identifiable
{
    var id = UUID()
    let type: String
    let value: Double
    
}



////
////  ContentView.swift
////  Kwasniewska_Kurowski_Projekt
////
////  Created by Patrycja Kwaśniewska on 07/06/2023.
////
//
//import SwiftUI
//import CoreData
//import Charts
//
//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    //  INCOME
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Income.name, ascending: true)], animation: .default)
//    private var incomes: FetchedResults<Income>
//
//    //  EXPENSE
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Expense.name, ascending: true)], animation: .default)
//    private var expenses: FetchedResults<Expense>
//
//    //  CATEGORY INCOME
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryIncome.name, ascending: true)], animation: .default)
//    private var categoryIncomes: FetchedResults<CategoryIncome>
//
//    //  CATEGORY EXPENSE
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryExpense.name, ascending: true)], animation: .default)
//    private var categoryExpenses: FetchedResults<CategoryExpense>
//
//    //  SALDO
//    var totalIncome: Decimal {
//        incomes.reduce(Decimal(0)) { $0 + ($1.amount?.decimalValue ?? 0) }
//    }
//
//    var totalExpense: Decimal {
//        expenses.reduce(Decimal(0)) { $0 + ($1.amount?.decimalValue ?? 0) }
//    }
//
//    var saldo: Decimal {
//        totalIncome - totalExpense
//    }
//
//    //  CHART
//    @State private var isCreateUserViewPresented = false
//    @State private var chartItems: [ChartItem] = []
//
//
//
//    var body: some View {
//        NavigationView {
//
//            VStack {
//                HStack {
//                    NavigationLink(destination: SaldoView()) {
//                        VStack {
//                            Text("Saldo: \(saldo.description)")
//                                .font(.title)
//                                .foregroundColor(.black)
//                                .frame(width: 150, height: 80)
//                                .background(Color(red: 0.8, green: 0.6, blue: 0.9)) // Jasny fiolet
//                                .cornerRadius(10)
//                                .padding(20)
//                        }
//                    }
//
//                    Spacer()
//
//                    NavigationLink(destination: Profile()) {
//                        Image(systemName: "person.fill")
//                            .font(.system(size: 45)) // Powiększanie ikonki
//                            .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.6)) // Ciemny fiolet
//                            .padding(30)
//                    }
//                }
//
//                Spacer()
//
//                VStack {
//                    Chart(chartItems) { item in
//                        BarMark(x: .value("Total income", item.type), y: .value("Total expense", item.value))
//                    }
//                    .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.6)) // Ciemny fiolet
//                    .background(
//                        LinearGradient(
//                            gradient: Gradient(colors: [
//                                Color(red: 0.9, green: 0.7, blue: 1.0),
//                                Color(red: 0.8, green: 0.6, blue: 0.9)
//                            ]),
//                            startPoint: .leading,
//                            endPoint: .trailing
//                        )
//                    )
//                    .frame(maxHeight: 500)
//                    .padding(.horizontal, 15)
//                    .padding(.vertical, 20)
//                }
//
//
//                Spacer()
//
//                HStack {
//                    Spacer()
//
//                    NavigationLink(destination: IncomeView()) {
//                        Text("+")
//                            .font(.largeTitle)
//                            .foregroundColor(.white)
//                            .frame(width: 110, height: 80)
//                            .background(Color(red: 0.4, green: 0.2, blue: 0.6)) // Ciemny fiolet
//                            .cornerRadius(10)
//                    }
//                    .onAppear() {
//                        addCategoryIncome()
//                        addCategoryExpense()
//                        //deleteAllData()
//                        viewContext.refreshAllObjects()
//                    }
//
//
//
//                    Spacer()
//
//                    NavigationLink(destination: ExpenseView()) {
//                        Text("-")
//                            .font(.largeTitle)
//                            .foregroundColor(.white)
//                            .frame(width: 110, height: 80)
//                            .background(Color(red: 0.8, green: 0.6, blue: 0.9)) // Jasny fiolet
//                            .cornerRadius(10)
//                    }
//
//
//                    Spacer()
//                }
//
//                Spacer()
//                Spacer()
//                Spacer()
//            }
//            .navigationBarTitleDisplayMode(.inline)
//
//        }
//    }
//
//    private func addCategoryIncome() {
//        if categoryIncomes.isEmpty {
//            var newCategory = CategoryIncome(context: viewContext)
//            newCategory.name = "Salary"
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//
//            newCategory = CategoryIncome(context: viewContext)
//            newCategory.name = "Prize"
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//
//            newCategory = CategoryIncome(context: viewContext)
//            newCategory.name = "Gift"
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func addCategoryExpense() {
//        if categoryExpenses.isEmpty {
//            var newCategory = CategoryExpense(context: viewContext)
//            newCategory.name = "Bills"
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//
//            newCategory = CategoryExpense(context: viewContext)
//            newCategory.name = "Sport"
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//
//            newCategory = CategoryExpense(context: viewContext)
//            newCategory.name = "Food"
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//
//            newCategory = CategoryExpense(context: viewContext)
//            newCategory.name = "Fun"
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    // USUWANIE WSZYSTKICH DANYCH
//    private func deleteAllData() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CategoryIncome")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try viewContext.execute(deleteRequest)
//            try viewContext.save()
//        } catch {
//            print("Błąd podczas usuwania danych: \(error.localizedDescription)")
//        }
//    }
//
//
//
//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//        }
//    }
//}
//
////  ZIDENTYFIKOWANY WYKRES
//struct ChartItem: Identifiable
//{
//    var id = UUID()
//    let type: String
//    let value: Double
//
//}
//
//struct Previews_ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
