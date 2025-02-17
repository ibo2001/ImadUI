<div align="center">
    <img src="https://raw.githubusercontent.com/ibo2001/ImadUI/refs/heads/master/Resources/ImadUILogo.jpg" width="400pt">
</div>

---

<div align="center">
    <img src=https://img.shields.io/badge/Swift-6.0-orange.svg>
    <img src=https://img.shields.io/badge/Platform-iOS_16.0-green.svg>
    <img src=https://img.shields.io/badge/Platform-macOS_13.0-green.svg>
</div>
<div align="center">
    <a href="">
        <img alt="Website" src=https://img.shields.io/badge/Website-grey.svg>
    </a>
    <a href="https://x.com/ibo2001">
        <img src=https://img.shields.io/badge/Twitter-00acee.svg>
    </a>
</div>

---

**ImadUI** is a Swift package containing a SwiftUI controls, for now it just contains a RulerSlider, I will try to
update it as I can with any UI i think will be usefull to the comunity : <br>

## RulerPicker

<div align="center">
    <img src="https://raw.githubusercontent.com/ibo2001/ImadUI/refs/heads/master/Resources/ImadUIRulerPicker.png" width="400pt">
</div>
<br>

## RainbowOverlay

<div align="center">
    <img src="https://raw.githubusercontent.com/ibo2001/ImadUI/refs/heads/master/Resources/RainbowOverlay.png" width="400pt">
</div>
<br>

## PagesPicker

<div align="center">
    <img src="https://raw.githubusercontent.com/ibo2001/ImadUI/refs/heads/master/Resources/PagesPicker.png" width="400pt">
</div>
<br>
## Installation

```Text
dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/ibo2001/ImadUI", .upToNextMajor(from: "0.1.0")),
],
```

## Usage

> Before using anything be sure to `import ImadUI` in the target swift file.

```Swift
@State private var selectedValue: Double = 1.0
@State private var isLoading: Bool = true

@State private var isLoading: Bool = true
@State private var selectedPage: Int?
@State private var text: String = ""
    
var body: some View {
    ...
    // RulerPicker
    RulerPicker(selectedValue:$selectedValue,
                in range: ClosedRange<Double> = 0.5...3.5,
                tickPosition:VerticalAlignment = .center,
                minorTickHeight: CGFloat = 12,
                tickColor: Color = .secondary,
                majorTickColor: Color = .primary,
                indicatorColor: Color = Color(.tintColor)
    
    ...
    // RainbowOverlay
    .overlay{
            if isLoading {
                RainbowOverlay(
                    radius: 70,
                    rainbowWidth: 50,
                    blurRadius: 20,
                    animationDuration: 5
                )
            }
        }
    
    
    ...
    // PagesPicker
    VStack {
        Text(text)
            .foregroundColor(.red)
            .contentTransition(.numericText())
            .font(.system(size: 20, weight: .bold, design: .default))
        
        PagesPicker(selectedValue:$selectedPage,in: 1...604,
                    pageImage: Image(systemName: "person"),pageFillingColor: .green.opacity(0.2))
        .frame(height: 40)
        
        if let selectedPage {
            Text(String(format: "%d", selectedPage))
                .foregroundColor(.red)
                .contentTransition(.numericText())
                .font(.system(size: 20, weight: .bold, design: .default))
        }
    }
    .onChange(of: selectedPage) {
        if let selectedPage {
            text = String(format: "Page number %d", selectedPage)
        }
    }
    .onAppear {
        selectedPage = 1
    }
}
```

### License

=======

This code is distributed under the terms and conditions of the MIT license.
