# AnimatedChart

AnimatedChart is a simple chart app for iOS which is animated with a wave animation. The inspiration for this project came from my [WeatherApp](https://github.com/danhenshaw/WeatherApp_V2) project so the axis labels are reflective of what I would require for that project


<img src="https://github.com/danhenshaw/AnimatedChart/blob/master/Screenshot/AnimatedChartPreview.gif">


## Objective

Create a graph that will be animated with a wave animation to indicate variances or an error margin in the values. I also wanted to explore UIBezierPath and CADisplayLink and custom animations.


## Solution

From the view controller, the app implements a chart based on randomly generated data and then displays that in a line graph that has an animated wave. To initiate the chart, along with the graph data values, it is also necessary to provide the x- and y-axis labels.

No third party frameworks have been used in the development of this project. 


## Features

- The chart background is drawn on its own layer. The y-axis labels are evenly spaced along the y-axis and horizontal lines are drawn in between each value. The space for the x-axis labels is taken in to account when spacing the horizontal lines
-  The same method applies for the x-axis labels. After removing the width of the y-axis labels from the overall width, the remaining width is divided into the required space for the x-axis labels. 
- The chart is drawn on a seperate layer and takes the users data (which needs to be a percentage) and coverts it in the CGPoints.
- The chart is animated with a wave animation which uses a sin function to modulate the chart at a given amplitude and frequency.
- Tapping on the screen removes the current chart and reloads itself with new randomly generated data.
- Currently the wave animation is optional and it is possible to show a static chart.
- The default option is for the chart to be filled however this can also be turned off to show a single line.


## Further improvements

While the current state of the app is sufficient for what was required in the [WeatherApp](https://github.com/danhenshaw/WeatherApp_V2) , there are some obvious areas for improvement to make the chart more flexible and re-useable. 

Such features to be developed in the futures include:

- Ability to remove x- and y-axis labels or add labels or to have multiple axis.
- Additional animation styles such as spring loading and unloading
- Additional visual features such as gradient fill, straight line graph, dot points etc.


## Author

Daniel Henshaw, danieljhenshaw@gmail.com


## License

BitcoinTracker is available under the [MIT license](https://opensource.org/licenses/MIT)
