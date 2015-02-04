library(rflot)

#Simple scatter
flotChart(faithful) %>%
  flotSeries(x=eruptions,y=waiting, label= '', points=list(show=T))

#Simple bar chart, numerical x-axis
flotChart(data.frame(discoveries=as.numeric(discoveries),year=as.numeric(time(discoveries))-1860)) %>%
  flotSeries(x=year, y=discoveries, bars=list(show=T), hoverable=T) %>%
  flotOptions(xaxis=list(axisLabel="Year starting in 1860"))

#Stacked bar chart example with a categorical x-axis and custom tooltips
#Possible tooltip plugin bug: For some reason %x does not work as it should here
#however xval works fine
flotChart(as.data.frame(xtabs(ncases ~ agegp+alcgp, data = esoph),stringsAsFactors = F)) %>%
  flotSeries(x=agegp, y=Freq, group=alcgp, stack=T, hoverable=T
             ,label= 'Alcohol Consumption: '
             ,bars=list(show=T, barWidth= 0.6,align="center")) %>%
  flotOptions(yaxis=list(axisLabel='Count')
              ,xaxis=list(axisLabel="Age Group"
                ,mode="categories"
                ,tickLength= 0
              )
              ,tooltipOpts=list(
                content=htmlwidgets::JS("function(label, xval, yval, flotItem) {
                  return 'Age Group: '+xval+' <br> Count: %y <br> %s';}")))

#Fancy bars: Dodged/stacked bar chart with a categorical x-axis
#Possible tooltip plugin bug: For some reason %x does not work as it should here
#however xval works fine
flotChart(as.data.frame(xtabs(ncases ~ agegp+alcgp, data = esoph),
stringsAsFactors = F)) %>%
  flotSeries(x=agegp, y=Freq, group=alcgp,stack=T, hoverable=T
             ,label= 'Alcohol Consomption: '
             ,bars=list(show=T, fill=0.1, order=1,barWidth= 0.2)) %>%
  flotSeries(data=as.data.frame(xtabs(ncases ~ agegp+tobgp, data = esoph)
                    ,stringsAsFactors = F)
               ,x=agegp, y=Freq, group=tobgp, stack=T, hoverable=T
               ,label= 'Tobaco Consumption: '
               ,bars=list(show=T, fill=.7, order=2, barWidth= 0.2)) %>%
  flotSeries(data=as.data.frame(xtabs(ncontrols ~ agegp, data = esoph)
                    ,stringsAsFactors = F)
                ,x=agegp, y=Freq, hoverable=T
                ,label= 'Number of Controls'
                ,bars=list(show=T, order=3, barWidth= 0.2)) %>%
  flotOptions(yaxis=list(axisLabel='Count')
              ,xaxis=list(axisLabel="Age Group"
                          ,mode="categories"
                          ,tickLength= 0
              )
              ,legend=list(position='nw')
              ,tooltipOpts=list(
                content=htmlwidgets::JS("function(label, xval, yval, flotItem) {
                  return 'Age Group: '+xval+' <br> Count: %y <br> %s';}"))
              )

#Simple line chart
t <- seq(0, 2 * pi, length = 20)
data <- data.frame(x = sin(t), y = cos(t))
flotChart(data, width=300, 300) %>%
  flotSeries(x=x, y=y, label= '') %>%
  flotOptions(yaxis=list(min=-1, max=1)
              ,xaxis=list(min=-1, max=1))

