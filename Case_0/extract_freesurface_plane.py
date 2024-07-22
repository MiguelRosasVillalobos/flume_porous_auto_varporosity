# trace generated using paraview version 5.12.0
#import paraview
#paraview.compatibility.major = 5
#paraview.compatibility.minor = 12

#### import the simple module from the paraview
from paraview.simple import *
#### disable automatic camera reset on 'Show'
paraview.simple._DisableFirstRenderCameraReset()

# create a new 'Open FOAM Reader'
case_$ifoam = OpenFOAMReader(registrationName='Case_$i.foam', FileName='/home/miguel/Desktop/OpenFOAM_Proyects/flume_porous_auto_vardouble/Case_$i/Case_$i.foam')

# Properties modified on case_5foam
case_$ifoam.SkipZeroTime = 0
case_$ifoam.CaseType = 'Decomposed Case'

# get active view
renderView1 = GetActiveViewOrCreate('RenderView')

# show data in view
case_$ifoamDisplay = Show(case_$ifoam, renderView1, 'UnstructuredGridRepresentation')

# trace defaults for the display properties.
case_$ifoamDisplay.Representation = 'Surface'

# reset view to fit data
renderView1.ResetCamera(False, 0.9)

# get the material library
materialLibrary1 = GetMaterialLibrary()

# get animation scene
animationScene1 = GetAnimationScene()

# update animation scene based on data timesteps
animationScene1.UpdateAnimationUsingDataTimeSteps()

# create a new 'Slice'
slice1 = Slice(registrationName='Slice1', Input=case_$ifoam)

# set active source
SetActiveSource(case_$ifoam)

# create a new 'Slice'
slice1_1 = Slice(registrationName='Slice1', Input=case_$ifoam)

# Properties modified on case_5foam
case_$ifoam.MeshRegions = ['internalMesh']
case_$ifoam.CellArrays = ['U', 'alpha.water', 'p', 'p_rgh', 'porosity']

# Properties modified on slice1_1.SliceType
slice1_1.SliceType.Origin = [$p, 0.2, 0.005]

# show data in view
slice1_1Display = Show(slice1_1, renderView1, 'GeometryRepresentation')

# trace defaults for the display properties.
slice1_1Display.Representation = 'Surface'

# hide data in view
Hide(case_$ifoam, renderView1)

# update the view to ensure updated data information
renderView1.Update()

# create a new 'Slice'
slice2 = Slice(registrationName='Slice2', Input=slice1_1)

# Properties modified on slice2.SliceType
slice2.SliceType.Normal = [0.0, 0.0, 1.0]

# show data in view
slice2Display = Show(slice2, renderView1, 'GeometryRepresentation')

# trace defaults for the display properties.
slice2Display.Representation = 'Surface'

# hide data in view
Hide(slice1_1, renderView1)

# update the view to ensure updated data information
renderView1.Update()

# create a new 'Contour'
contour1 = Contour(registrationName='Contour1', Input=slice2)

# Properties modified on contour1
contour1.Isosurfaces = [0.5]

# show data in view
contour1Display = Show(contour1, renderView1, 'GeometryRepresentation')

# trace defaults for the display properties.
contour1Display.Representation = 'Surface'

# hide data in view
Hide(slice2, renderView1)

# show color bar/color legend
contour1Display.SetScalarBarVisibility(renderView1, True)

# update the view to ensure updated data information
renderView1.Update()

# get color transfer function/color map for 'alphawater'
alphawaterLUT = GetColorTransferFunction('alphawater')

# get opacity transfer function/opacity map for 'alphawater'
alphawaterPWF = GetOpacityTransferFunction('alphawater')

# get 2D transfer function for 'alphawater'
alphawaterTF2D = GetTransferFunction2D('alphawater')

# set active source
SetActiveSource(slice1_1)

# toggle interactive widget visibility (only when running from the GUI)
ShowInteractiveWidgets(proxy=slice1_1.SliceType)

# set active source
SetActiveSource(slice2)

# toggle interactive widget visibility (only when running from the GUI)
HideInteractiveWidgets(proxy=slice1_1.SliceType)

# toggle interactive widget visibility (only when running from the GUI)
ShowInteractiveWidgets(proxy=slice2.SliceType)

# set active source
SetActiveSource(contour1)

# toggle interactive widget visibility (only when running from the GUI)
HideInteractiveWidgets(proxy=slice2.SliceType)

# save data
SaveData('/home/miguel/Desktop/OpenFOAM_Proyects/flume_porous_auto_vardouble/Case_$i/data$p.csv', proxy=contour1, WriteTimeSteps=1,
    ChooseArraysToWrite=1,
    PointDataArrays=['alpha.water'])

#================================================================
# addendum: following script captures some of the application
# state to faithfully reproduce the visualization during playback
#================================================================

# get layout
layout1 = GetLayout()

#--------------------------------
# saving layout sizes for layouts

# layout/tab size in pixels
layout1.SetSize(1216, 848)

#-----------------------------------
# saving camera placements for views

# current camera placement for renderView1
renderView1.CameraPosition = [2.284484902405622, 0.3922075017932631, 0.3083536189692649]
renderView1.CameraFocalPoint = [2.474636217270496, 0.15646890124654644, -0.17894575777704808]
renderView1.CameraViewUp = [0.09439054078611495, 0.9101193030990126, -0.4034517070687302]
renderView1.CameraParallelScale = 10.155286451089824


##--------------------------------------------
## You may need to add some code at the end of this python script depending on your usage, eg:
#
## Render all views to see them appears
# RenderAllViews()
#
## Interact with the view, usefull when running from pvpython
# Interact()
#
## Save a screenshot of the active view
# SaveScreenshot("path/to/screenshot.png")
#
## Save a screenshot of a layout (multiple splitted view)
# SaveScreenshot("path/to/screenshot.png", GetLayout())
#
## Save all "Extractors" from the pipeline browser
# SaveExtracts()
#
## Save a animation of the current active view
# SaveAnimation()
#
## Please refer to the documentation of paraview.simple
## https://kitware.github.io/paraview-docs/latest/python/paraview.simple.html
##--------------------------------------------
