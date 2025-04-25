import SwiftUI

enum TapTapiocaTabBarStyle {
    case standard
    case scrollable
}

public struct TapiocaTabBar: View {
    
    var style: TapTapiocaTabBarStyle = .standard
    let color : Color
    
    @Namespace private var animationNamespace
    
    
    // Déclare une propriété liée à une valeur externe (par exemple un @State dans le parent)
    @Binding var selectedIndex: Int
    let items: [TapiocaTabBarItem]
        
    // Initialiseur personnalisé
    public init(selectedIndex: Binding<Int>, items: [TapiocaTabBarItem], color : Color = .orange) {
        // On affecte la valeur reçue (de type Binding<Int>) à la variable de stockage _selectedIndex
        // Cela configure correctement la propriété @Binding selectedIndex
        self._selectedIndex = selectedIndex
        self.items = items
        self.color = color
    }
    
    var heightSelectedItem : CGFloat = 50
    var radiusLarge : CGFloat {
        return heightSelectedItem / 2
    }
    var radiusSmall : CGFloat {
        return heightSelectedItem / 4
    }
    
    public var body: some View {
        GeometryReader { _ in
        
            GeometryReader { _ in
                
                HStack {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                selectedIndex = index
                            }
                        }) {
                            TabBarItemView(
                                item: item,
                                isSelected: index == selectedIndex,
                                color: color,
                                height: heightSelectedItem,
                                radiusLarge: radiusLarge,
                                radiusSmall: radiusSmall,
                                animationNamespace: animationNamespace,
                                isFirst: index == 0
                            )
                        }
                        .foregroundColor(index == selectedIndex ? color : .white.opacity(0.5))
                        
                    }
                }
                .frame(height: heightSelectedItem)
                .padding(0)
                
                
            }
            .frame(height: heightSelectedItem )
            .clipShape(CustomRoundedRectangle(topLeft: radiusSmall,
                                              topRight: radiusSmall,
                                              bottomLeft: radiusLarge,
                                              bottomRight: radiusLarge))
            .padding(.horizontal, 16)
            .padding(.top , 16)
            
        }.frame(height: heightSelectedItem + 16)
            .background(color)
            .ignoresSafeArea()
    }
}

struct ContentView: View {
    @State private var selectedTab = 0
    let tabs = [
        TapiocaTabBarItem(icon: Image(systemName:"house.fill"), title: "Home"),
        TapiocaTabBarItem(icon: Image(systemName: "star.fill"), title: "Favorites"),
        TapiocaTabBarItem(icon: Image(systemName: "person.fill"), title: "Profile")
    ]
    
    var body: some View {
        VStack {
            Spacer()
            // Affichage du contenu ici
            Text("Selected tab: \(tabs[selectedTab].title)")
            Spacer()
            TapiocaTabBar(selectedIndex: $selectedTab, items: tabs)
        }
    }
}

#Preview {
    ContentView()
}


struct CustomRoundedRectangle: Shape {
    
    var topLeft: CGFloat = 0
    var topRight: CGFloat = 0
    var bottomLeft: CGFloat = 0
    var bottomRight: CGFloat = 0

    init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    init(radius: CGFloat) {
        self.topLeft = radius
        self.topRight = radius
        self.bottomLeft = radius
        self.bottomRight = radius
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let tl = min(min(topLeft, rect.width / 2), rect.height / 2)
        let tr = min(min(topRight, rect.width / 2), rect.height / 2)
        let bl = min(min(bottomLeft, rect.width / 2), rect.height / 2)
        let br = min(min(bottomRight, rect.width / 2), rect.height / 2)

        path.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))

        // top line
        path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - tr, y: rect.minY + tr),
                    radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        // right line
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
        path.addArc(center: CGPoint(x: rect.maxX - br, y: rect.maxY - br),
                    radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        // bottom line
        path.addLine(to: CGPoint(x: rect.minX + bl, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bl, y: rect.maxY - bl),
                    radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        // left line
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))
        path.addArc(center: CGPoint(x: rect.minX + tl, y: rect.minY + tl),
                    radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}

private struct TabBarItemView: View {
    let item: TapiocaTabBarItem
    let isSelected: Bool
    let color: Color
    let height: CGFloat
    let radiusLarge: CGFloat
    let radiusSmall: CGFloat
    let animationNamespace: Namespace.ID
    let isFirst: Bool

    var body: some View {
        HStack(spacing: 15) {
            item.icon.renderingMode(.template)
                .resizable()
                .frame(width: 22, height: 22)

            if isSelected {
                Text(item.title)
                    .font(.system(size: 16, weight: .bold))
            }
        }
        .frame(height: height)
        .padding(.horizontal, isSelected ? 30 : 10)
        .padding(.vertical, 0)
        .background(
            ZStack {
                if isSelected {
                    CustomRoundedRectangle(
                        topLeft: isFirst ? radiusSmall : radiusLarge,
                        topRight: radiusLarge,
                        bottomLeft: isFirst ? radiusSmall : radiusLarge,
                        bottomRight: radiusLarge
                    )
                    .fill(Color.white)
                    .matchedGeometryEffect(id: "selection", in: animationNamespace)
                }
            }
        )
    }
}
