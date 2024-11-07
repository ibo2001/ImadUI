<div align="center">
    <img src="https://raw.githubusercontent.com/ibo2001/ImadUI/refs/heads/master/Resources/ImadUILogo.jpg" width="400pt">
</div>

---

<div align="center">
    <img src=https://img.shields.io/badge/Swift-5.2-orange.svg>
    <img src=https://img.shields.io/badge/Platform-iOS_16.1-green.svg>
    <img src=https://img.shields.io/badge/BETA-0.2.0-red.svg>
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

<div align="center">
    <img src="https://raw.githubusercontent.com/ibo2001/ImadUI/refs/heads/master/Resources/ImadUIRulerPicker.png" width="400pt">
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

var body: some View {
    ...
    RulerPicker(selectedValue:$selectedValue)
    ...
}
```

### License

=======

This code is distributed under the terms and conditions of the MIT license.
