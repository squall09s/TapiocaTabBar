import SwiftUI

public enum TapTapiocaTabBarStyle {
    // In Flow style (default), the focus fluidly moves between tabs with a smooth animated capsule that follows the selected item.
    //The label appears only on the active tab, giving the navigation a clean, lightweight, and dynamic feeling.
    case flow
    // In Anchor style, the main tab remains visually emphasized at all times with a fixed capsule and title, even when navigating to other tabs.
    //Selection is indicated through subtle color and opacity changes, maintaining the spotlight on the primary action tab.
    case anchor
}



public struct TapiocaTabBar: View {
    
    var style: TapTapiocaTabBarStyle
    let color : Color
    
    @Namespace private var animationNamespace
    
    
    // Déclare une propriété liée à une valeur externe (par exemple un @State dans le parent)
    @ObservedObject var viewModel: TapiocaTabBarViewModel
        
    // Initialiseur personnalisé
    public init(viewModel: TapiocaTabBarViewModel, color : Color = .orange, style : TapTapiocaTabBarStyle = .flow) {
        self.viewModel = viewModel
        self.color = color
        self.style = style
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
                    ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                viewModel.selectedIndex = index
                            }
                        }) {
                            TabBarItemView(
                                item: item,
                                isSelected: index == viewModel.selectedIndex,
                                height: heightSelectedItem,
                                radiusLarge: radiusLarge,
                                radiusSmall: radiusSmall,
                                animationNamespace: animationNamespace,
                                isFirst: index == 0,
                                style: style
                            )
                        }
                        .foregroundColor(index == viewModel.selectedIndex ? ( (style == .flow || index == 0) ? color : .white) : .white.opacity(0.5) )
                        
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
    @ObservedObject var item: TapiocaTabBarItem
    let isSelected: Bool
    let height: CGFloat
    let radiusLarge: CGFloat
    let radiusSmall: CGFloat
    let animationNamespace: Namespace.ID
    let isFirst: Bool
    let style: TapTapiocaTabBarStyle

    func showTitle() -> Bool {
        return (isSelected && style == .flow) || (style == .anchor && isFirst)
    }
    
    var body: some View {
        HStack(spacing: 15) {
            item.icon.renderingMode(.template)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 22, height: 22)

            if self.showTitle() {
                Text(item.title)
                    .font(.system(size: 16, weight: .bold)).lineLimit(1).minimumScaleFactor(0.5)
            }
        }
        .frame(height: height)
        .padding(.horizontal, self.showTitle() ? 30 : 10)
        .padding(.vertical, 0)
        .background(
            ZStack {
                if ( isSelected && style == .flow) || (style == .anchor && isFirst) {
                    CustomRoundedRectangle(
                        topLeft: isFirst ? radiusSmall : radiusLarge,
                        topRight: radiusLarge,
                        bottomLeft: isFirst ? radiusSmall : radiusLarge,
                        bottomRight: radiusLarge
                    )
                    .fill(style == .flow ? Color.white : ( isSelected ? .white : .white.opacity(0.1) ))
                    .matchedGeometryEffect(id: "selection", in: animationNamespace)
                }
            }
        )
    }
}
