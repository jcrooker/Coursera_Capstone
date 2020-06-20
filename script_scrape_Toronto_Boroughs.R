## Scrape Toronto Neighborhoods for Week 3 Project
my_url<-"https://en.wikipedia.org/wiki/List_of_postal_codes_of_Canada:_M"
my_con<-file(my_url,"r")

my_txt<-readLines(my_con,-1)
close(my_con)

tab_loc<-grep("[<]table class[=]\"wikitable sortable\"[>]",my_txt)
tab_end_loc<-grep("[<][/]table[>]",my_txt)
tab_end_loc<-tab_end_loc[tab_end_loc>tab_loc[1]]

chunk<-my_txt[tab_loc[1]:tab_end_loc[1]]

tr_loc<-grep("[<][/]*tr[>]",chunk)

my_datfr<-NULL
for (i in seq(3,length(tr_loc),2)) {
  i_datfr<-data.frame(Postal_Code=gsub("<.*?>","",chunk[tr_loc[i]+1]),
                      Borough=gsub("<.*?>","",chunk[tr_loc[i]+3]),
                      Neighborhood=gsub("<.*?>","",chunk[tr_loc[i]+5]),
                      stringsAsFactors = FALSE)
  if (!is.null(my_datfr)) {
    my_datfr<-rbind(my_datfr,i_datfr)
  } else {
    my_datfr<-i_datfr
  }
}

write.table(my_datfr,file="Toronto_Boroughs.csv",sep=",",row.names=FALSE)


