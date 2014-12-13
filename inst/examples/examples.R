library(rflot)

#Simple scatter
data<-data.table(faithful)
flotChart(data.table(faithful)) %>%
  flotSeries(x=eruptions,y=waiting, label= '', points=list(show=T))

#Simple bar chart
flotChart(data.table(mtcars)[,list(count=.N),by=list(cyl)]) %>%
  flotSeries(x=cyl, y=count
             ,label= ''
             ,bars=list(show=T, barWidth= 0.6,align="center")) %>%
  flotOptions(yaxis=list(axisLabel='Count')
              ,xaxis=list(axisLabel="Number of Cylinders"
                ,mode="categories"
                ,tickLength= 0
              ))

#Fancy bars: Dodged/stacked bar chart
#Q:Why do I have to order cyl?
#A:From stacking plugin: The plugin assumes the data is sorted on x (or y if stacking horizontally).
flotChart(data.table(mtcars)[,list(count=.N),by=list(cyl)],height=550, width=1100) %>%
  flotSeries(x=cyl, y=count
             ,label= 'Total'
             ,hoverable=T
             ,bars=list(show=T, order = 1, barWidth= 0.3)) %>%
  flotSeries(data=data.table(mtcars)[,list(count=.N),by=list(cyl, gear)][order(cyl),], x=cyl, y=count, group=gear
            ,label= 'Count w/ Number of gears: '
            ,hoverable = T
            ,stack='gear'
            ,bars=list(show=T,  order=2, barWidth= 0.3)) %>%
  flotOptions(yaxis=list(axisLabel='Count')
              ,xaxis=list(axisLabel="Number of Cylinders"
                          ,mode="categories"
                          ,tickLength= 0
              ))

#Simple line chart
t <- seq(0, 2 * pi, length = 20)
data <- data.table(x = sin(t), y = cos(t))
flotChart(data, width=300, 300) %>%
  flotSeries(x=x, y=y, label= '') %>%
  flotOptions(yaxis=list(min=-1, max=1)
              ,xaxis=list(min=-1, max=1))

