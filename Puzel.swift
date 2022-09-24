
import ScreenSaver
import SwiftUI

struct PuzelUIView: View {
    
    @State private var hour = updateTime(.hour)
    @State private var minute = updateTime(.minute)
    @State private var date = updateDate()
    
    let timeSize: CGFloat = 120
    
    @State private var isDimmed = false
    
    let separatorTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(hour)
                    .foregroundColor(.white)
                    .font(.system(size: timeSize, weight: .black, design: .serif))
                VStack {
                    Spacer()
                    Text(":")
                        .foregroundColor(isDimmed ? .init(white: 0.4) : .white)
                        .font(.system(size: timeSize, weight: .black, design: .serif))
                        .padding(.bottom, 30)
                        .onReceive(separatorTimer) { output in
                            isDimmed.toggle()
                            hour = updateTime(.hour)
                            minute = updateTime(.minute)
                            date = updateDate()
                        }
                        .animation(.easeInOut(duration: 1), value: isDimmed)
                    Spacer()
                }
                .frame(height: 100)
                Text(minute)
                    .foregroundColor(.white)
                    .font(.system(size: timeSize, weight: .black, design: .serif))
            }
            Text(date)
                .foregroundColor(.init(white: 0.9))
                .font(.system(size: 70, weight: .black, design: .serif))
        }
    }
}

enum Time {
    case hour
    case minute
}

func updateTime(_ type: Time?) -> String {
    if type == .hour {
        return Date().formatted(.dateTime.hour(.twoDigits(amPM: .omitted)))
    } else if type == .minute {
        return Date().formatted(.dateTime.minute(.twoDigits))
    }
    return Date().formatted(.dateTime.hour().minute())
}

func updateDate() -> String {
    return Date().formatted(.dateTime.weekday().day().month())
}


class PuzelView: ScreenSaverView {
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
        let myView = NSHostingView(rootView: PuzelUIView())
        myView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(myView)
        myView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        myView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
