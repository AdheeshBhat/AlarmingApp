import SwiftUI

struct RemindersScreen: View {
    //@Environment(\.dismiss) var dismiss also works for back button
    @Environment(\.presentationMode) private var
        presentationMode: Binding<PresentationMode>
    @State private var home1_pressed : Int = 1
    @State private var navigate_to_home_screen : Bool = false
    @State private var notifications : Bool = false
    @State private var isRemindersViewOn : Bool = false
    @Binding var cur_screen: Screen
    @Binding var DatabaseMock: Database
    
    var body: some View {
        //NOTIFICATION BELL BUTTON
        VStack {
            NotificationBellExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
            
            
        VStack {
            Text("Reminders")
                .font(.largeTitle)
                .fontWeight(.bold)
                //.padding(.top)
            
            .padding()
            HStack {
                Button(action: {
                    //put actions here
                }) {
                    Text("Day")
                        .font(.title)
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .background(Color.gray)
                .cornerRadius(5)
                
                
                Button(action: {
                    //put actions here
                }) {
                    Text("Week")
                        .font(.title)
                }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .background(Color.black)
                    .cornerRadius(5)
                
                
                Button(action: {
                    //put actions here
                }) {
                    Text("Month")
                        .font(.title)
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .background(Color.gray)
                .cornerRadius(5)
                
                
            } //HStack ending
            .font(.headline)
            
            List {
                ReminderRow(title: "Pay Utility Bill", time: "03:30 PM", date: "Today")
                ReminderRow(title: "Make Doctor's Appointment", time: "05:45 AM", date: "May 6th")
                ReminderRow(title: "Reminder", time: "04:15 AM", date: "May 7th")
            }
            
            
            
            Toggle("Week Calendar View", isOn: $isRemindersViewOn)
                .padding()
            
            //SwitchToggleStyle(.blue, "Week Calendar 2", isOn: .constant(false))
            
            Spacer()
        } //VStack ending
        
        VStack {
            NavigationBarExperience(cur_screen: $cur_screen, DatabaseMock: $DatabaseMock)
        }
    
    } //body ending
    
} //struct ending


struct ReminderRow: View {
    var title: String
    var time: String
    var date: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Done")
                        .font(.subheadline)
                }
            }
            Spacer()
            Text(time)
                .font(.headline)
            Text(date)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
    }
}


#Preview {
    ContentView()
}
