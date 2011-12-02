class HamRadio

  def initialize()

  end

  def grid_encode(dms)

    # return nil if this isn't a valid gridsquare
    return nil if self.valid_gridsquare(dms) == nil
    grid = ''

    lat = dms[0].to_f+90
    lon = dms[1].to_f+180

    v = (lon/20).to_i
    lon -= (v*20)
    grid += ((?A.ord + v).chr).to_s # first letter

    v = (lat/10).to_i
    lat -= (v*10)
    grid += ((?A.ord + v).chr).to_s # second letter

    p3 = (lon/2).to_i
    grid += p3.to_s # third number
    p4 = (lat).to_i
    grid += p4.to_s # fourth number

    lon -= p3*2
    lat -= p4
    p3 = (?0.ord + p3.to_i).chr
    p4 = (?0.ord + p4).chr
    p5 = (12.ord * lon).to_i
    p6 = (24.ord * lat).to_i

    grid += ((?a.ord + p5).chr).to_s # fifth letter
    grid += ((?a.ord + p6).chr).to_s # sixth letter

  end

  def grid_decode(gridsquare)
    gridsquare = "EM13sf"
    gridsquare += 'MM' if gridsquare.count == 4

    a = gridsquare[0].ord - 'A'.ord
    b = gridsquare[1].ord - 'A'.ord
    c = gridsquare[2].ord - '0'.ord
    d = gridsquare[3].ord - '0'.ord
    e = gridsquare[4].upcase.ord - 'A'.ord
    f = gridsquare[5].upcase.ord - 'A'.ord
    lon = (a*20) + (c*2) + ((e+0.5)/12) - 180
    lat = (b*10) + d + ((f+0.5)/24) - 90
    [lat,lon]
  end

  def valid_gridsquare(grid)
    (grid =~ /[a-z][a-z]\d\d[a-z]*/i) != nil
  end

  def lookup_callsign(call)
    require 'nestful'

    c = Nestful.get 'http://callbytxt.org/db/'+call+'.json', :format => :json #=> {:json_hash => 1}
    c['calls']
  end

  def valid_callsign(call)
    (call =~ /^([BFGIKMNTW]|[A-Z0-9]{2})[0-9][A-Z0-9]{0,3}[A-Z]$/i) != nil
  end

end
