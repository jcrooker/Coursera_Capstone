# Las Vegas Zip code Miner
my_lv_zip_codes<-function() {
  options(warn=-1)
  url<-"https://zip-codes.com/city/nv-las-vegas.asp"
  my_con<-file(url,"r")
  my_txt<-readLines(my_con,-1)
  close(my_con)
  
  tb_loc<-grep("id=\"tblZIP\"",my_txt)
  tb_end<-grep("[<][/]table[>]",my_txt)
  my_line_loc<-tb_end[tb_end>tb_loc][1]
  
  my_chunks<-strsplit(my_txt[my_line_loc],"[<][/]tr[>]")[[1]]
  my_matrix<-matrix(NA,nrow=(length(my_chunks)-1),ncol=5)
  for (i in 1:(length(my_chunks)-1)) {
    i_chunk<-strsplit(my_chunks[i],"[<][/]td[>]")[[1]]
    j_vec<-rep(NA,length(i_chunk))
    for (j in 1:length(i_chunk)) {
      j_vec[j]<-gsub("<.*?>","",i_chunk[j])
    }
    my_matrix[i,]<-j_vec
  }
  my_datfr<-data.frame(my_matrix,stringsAsFactors = FALSE)
  names(my_datfr)<-c("ZIP","Type","County","Population","Area.Code")
  my_datfr$ZIP<-gsub("ZIP Code ","",my_datfr$ZIP)
  my_datfr$Population<-as.numeric(gsub("[,]","",my_datfr$Population))
  return(my_datfr[my_datfr$Population>0,])
}
# lv<-my_lv_zip_codes()
# write.table(lv,file="lv-zip-codes.csv",sep=",",row.names=FALSE)
