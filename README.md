# MOIRE EDITOR

Screen Recording: https://www.youtube.com/watch?v=dMObFB9nDLw&feature=youtu.be 

## Intentions of the Project
By designing a computation tool for a niche form of art from a blank slate, I intend to study how the tools are shaped by the art forms they create, and how the works of art in turn reflects the creation processes. 

## Software Architecture
### Requirements
Iterative UI prototyping requires interface components to be swappable, ideally without restarting the app

### Assumptions 
A moire is consisted of one or more overlaid moving patterns of the same size. A pattern isn’t necessarily consisted of uniform stripes. 

### Solution: Abstract major components with protocols to enable hot-swapping
#### The model managing the data of the moires: MoireModel class 
  - Each Moire object contains the pattern objects necessary to render itself, and can be encoded and stored on disk as a file
#### The controls that modifies the moire: CtrlViewController protocol
  -	Each ControlView controls one or more patterns (currently only one). It doesn’t have to know the moire it’s controlling, 
  as it always specifies the value of a particular attribute of the moire without knowing its current state. 
  This alleviates the synchronization issue between the model and the ControlViews
#### The views that render each pattern of the moire: PatternViewController protocol
  - Each PatternView knows the pattern it’s rendering but cannot modify it. 
#### The controller connecting the model, the controls and the views: PatternManager protocol
  - It manages the pairing between the ControlViews and the PatternViews, and decides which changes from the ControlViews to apply to avoid breaking the PatternViews. 
  
###	Major Components Hierachy
- MainViewController: PatternManager
  - MoireModel
  - ControlsViewController
    - CtrlViewController (1..)
  - MoireViewController
    - PatternViewController (1..) 
    
## Progresses Made and Next Steps
### Number of patterns per moire
Currently this number is 2 but it’s not hardcoded into any major component. With some work on the UI I will try to have up to 4 patterns per moire. 

### Representation of patterns
Currently, a pattern is consisted of identical stripes placed at uniform spacings. It is represented by four attributes only: speed, direction, blackWidth and whiteWidth. 
An alternative representation I used earlier was speed, direction, fillRatio and scaleFactor. It is less straightforward but maps well onto the Core Animation PatternView I initially built. 
One-to-one conversion between these two systems is done by the Utilities class. 
The next step may be to represent distorted stripes with nonuniform spacings, though I’m still working on the details. 

### Controls
Currently, there are two control schemes corresponding to the two representations of pattern I used. 
One controls speed, direction, fillRatio and scaleFactor; and the other controls speed, direction, blackWidth and whiteWidth. 
They feel quite different to use and I found myself switching between them to achieve a desired moire effect. 
Since both schemes prove valuable, the first step is to combine them into a ControlView that controls all six attributes. 
Since some attributes are inter-locked it will have to request the updated Moire from PatternManager to update its interface, a mechanism that’s already implemented. 
After that, I plan to have a new control scheme that controls all patterns at once in a top-down manner: 
While the existing two schemes operates on individual stripes, this one operates on the moire effect. 
Potential attributes include illusional direction, rhythm speed, brightness and contrast, though I’m still working on the details. 

### Rendering
I just finished a new PatternView backed by CAMetalLayer. While the previous one feels like a hack, this one renders the stripes and the spacings properly, 
moving at precisely the specified speed that may be changed in real time. The multi-sampling AA also significantly improved the moire effect. 
The first PatternView I made used white CALayers to tile the screen. Each tile contains a black sub-layer acting as the stripe. 
It is easy to build and performs well, but the CABasicAnimation has to be chained and isn’t very robust when I push and dismiss other controllers atop of it
(at least I haven’t found a good fix). It also requires interrupting and resuming the layer animation for each tile when changing speed so a UISegmentedControl has to be used in place of UISlider for that purpose. 
The next step is to make MetalPatternView capable of rendering distorted stripes. 
It should also render the masks using the shaders instead of the expensive UIView.mask property. 
