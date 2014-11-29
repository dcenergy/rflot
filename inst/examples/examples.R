library(flot)

#Simple scatter
data<-data.table(faithful)
flotChart(data.table(faithful)) %>%
  flotSeries(names=c('eruptions','waiting'), label= '', points=list(show=T)) %>%
  flotOptions(yaxis=list(axisLabel='Waiting Time')
              ,xaxis=list(axisLabel="Erruption Length"))

#Simple bar chart
flotChart(data.table(mtcars)[,list(count=.N),by=list(cyl)]) %>%
  flotSeries(names=c('cyl','count')
             ,label= ''
             ,bars=list(show=T, barWidth= 0.6,align="center")) %>%
  flotOptions(yaxis=list(axisLabel='Count')
              ,xaxis=list(axisLabel="Number of Cylinders"
                ,mode="categories"
                ,tickLength= 0
              ))

#Simple line chart
t <- seq(0, 2 * pi, length = 20)
data <- data.table(x = sin(t), y = cos(t))
flotChart(data, width=300, 300) %>%
  flotSeries(names=c('x','y'), label= '') %>%
  flotOptions(yaxis=list(min=-1, max=1)
              ,xaxis=list(min=-1, max=1))

