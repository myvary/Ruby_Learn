require '../class_all'
class US500
  def initialize
    @dow = DOW.new
  end
  def parse(url)
    list = Hash.new
    html = @dow.download_html(url)
    root_url = url[0,url.rindex('/')]+'/'
    html.xpath('//*[@id="leftdiv"]/div[1]/div[4]/table/tr[7]/td/table').each do |td|
      td.xpath('//a[@class ="txt-14"]').each do |tdd|
        if tdd.to_s.index(/[0-9].*年<.*>$/)
          year_html = @dow.download_html(root_url+tdd.get_attribute('href'))
          year_html.links.each do |link|
            if link.text =~/^[0-9].*年.*美国500强.*排行榜/
              list[link.text] =  root_url+link.href
            end
          end
        end
      end
    end
    list
  end
  def jiexi_next_page(url)
    html = @dow.download_html('http://www.fortunechina.com/fortune500/c/2012-05/07/content_98690.htm')

    while(true)
      f = 0
      html.links.each do |link|
        if link.text=~/下一页/
          f= 1
          puts link.text,'----->',link.href
          html = @dow.download_html('http://www.fortunechina.com/fortune500/c/2012-05/07/'+link.href)
        end
      end
      if f ==0
        break
      end
    end
  end
  def jiexi(fileName,url)
    html = @dow.download_html
    html.xpath('//*[@id="leftdiv"]/div/div/table').each do |tr|
      # puts tr.to_s
      tr.xpath('//tr').each do |tt|
        text = tt.content
        if text=~/[0-9]/
          # puts text[1,text.length].gsub(",",'，').gsub("\n",',')
          # file.syswrite(text[1,text.length].gsub(",",'，').gsub("\n",',')+"\n")
        end
      end
    end
  end
  def jiexi_list(list)
    list.each do |key,vol|
      p key,vol

      file = File.open(key+'.csv','ab+')
      html = @dow.download_html(vol)
      html.links.each do |link|
        if link.text=~/下一页/
          puts link.text,link.href
        end
      end
      html.xpath('//*[@id="leftdiv"]/div/div/table').each do |tr|

        # puts tr.to_s
        tr.xpath('//tr').each do |tt|
          text = tt.content
          if text=~/下一页/
            jiexi_next_page(vol)
          else
            if text=~/[0-9]/
              # puts text[1,text.length].gsub(",",'，').gsub("\n",',')
              # file.syswrite(text[1,text.length].gsub(",",'，').gsub("\n",',')+"\n")
            end
          end
        end
      end
    end
  end
end
url = 'http://www.fortunechina.com/fortune500/node_67.htm'
us = US500.new
# list = us.parse(url)

# us.jiexi(list)
us.jiexi_next_page('qwe')