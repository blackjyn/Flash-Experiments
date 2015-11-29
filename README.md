# Flash Experiments
A collection of legacy Flash and Pixel Bender effects and experiments done between 2007-2011
by **Edvard Toth** (http://edvardtoth.com)

Most of the content is available in form of FlashDevelop projects, with all supporting FLAs and asset files included, where applicable.

Contents
----------------
* **AnimationControl**
A little class that recursively crawls the entire hierarchy of nested animated MovieClips, and starts / stops every element within the hierarchy (not just the top level timeline). Demo SWF included.

* **AuroraMembrane**
A gnarly, twitchy, unsettling sound-visualizer effect, which relies on an animated perlinNoise map to supply pixel-displacement data. Soundtrack included.

* **BitmapDistorter**
A raw, back-to-the-essentials class that manipulates and distorts a texture using 2 triangles and UV coordinates.
Drag the corner handles to distort the image.

* **DepthMap**
A Pixel Bender-based depth-map shader, which can be used to define complex multiple depth-level occlusion/masking situations in a scene.
Adjust the red tag object to push it farther into the distance, and observe the gradual (and often partial) occlusion taking place.

* **DrawTriangleFabric**
An effect using the drawTriangles method, which is rendering 800 textured triangles based on vertex, index and UV information supplied by Vectors (the grid fades in and out to show the mesh structure).
The wavy movement as well as the dark/light patches are achieved with a continuously redrawn perlinNoise map: it functions as a height-map for the vertices, and it's also scaled and blended with the texture to generate the dark/light areas corresponding to the height information.

* **Hyperspace**
A 3D starfield of 1000 stars, and a bitmap-based "redshift" tail-effect. Relies heavily on the Vector class (a brand new addition to Flash at the time), which is essentially a fast, typed array. 

* **SimpleInterpolation**
A tiny, but extremely useful function, which interpolates a number within a numeric range into another corresponding number within another arbitrary numeric range.

* **SineScroll**
A Pixel Bender-based replica of the classic sine-scroll effect that was a staple of the Amiga demo-scene. Soundtrack included.

* **TagCloud**
A 3D cloud of tagwords, moving in a starfield-like manner.

* **TagMap**
Tagwords packed into a recursive tree-map grid structure.

* **WaveDisturbance**
Pixel Bender-based attenuated wave-disturbance effect over a bitmap, with adjustable parameters.
