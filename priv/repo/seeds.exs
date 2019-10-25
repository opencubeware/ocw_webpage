alias OcwWebpage.Constants.{RoundName, EventName}
alias OcwWebpage.DataAccess.Schemas.{Continent, Country, Round, Event, Person, Tournament, Result}
alias OcwWebpage.Repo

round_names = [
  ["First Round", 1],
  ["Second Round", 2],
  ["Third Round", 3],
  ["Final Round", 4],
  ["Combined First", 5],
  ["Combined Final", 6]
]

event_names = [
  ["3x3x3", 1],
  ["2x2x2", 2],
  ["4x4x4", 3],
  ["5x5x5", 4],
  ["6x6x6", 5],
  ["7x7x7", 6],
  ["3x3x3 Blindfolded", 7],
  ["3x3x3 Fewest Moves", 8],
  ["3x3x3 One-Handed", 9],
  ["3x3x3 With Feet", 10],
  ["Clock", 11],
  ["Megaminx", 12],
  ["Pyraminx", 13],
  ["Skewb", 14],
  ["Square-1", 15],
  ["4x4x4 Blindfolded", 16],
  ["5x5x5 Blindfolded", 17],
  ["3x3x3 Multi-Blind", 18]
]

continents = [
  ["Africa", 1],
  ["Asia", 2],
  ["Europe", 3],
  ["Multiple Continents", 4],
  ["North America", 5],
  ["Oceania", 6],
  ["South America", 7]
]

countries = [
  ["Afghanistan", "af", 2, 1],
  ["Albania", "al", 3, 2],
  ["Algeria", "dz", 1, 3],
  ["Andorra", "ad", 3, 4],
  ["Angola", "ao", 1, 5],
  ["Antigua and Barbuda", "ag", 5, 6],
  ["Argentina", "ar", 7, 7],
  ["Armenia", "am", 2, 8],
  ["Australia", "au", 6, 9],
  ["Austria", "at", 3, 10],
  ["Azerbaijan", "az", 3, 11],
  ["Bahamas", "bs", 5, 12],
  ["Bahrain", "bh", 2, 13],
  ["Bangladesh", "bd", 2, 14],
  ["Barbados", "bb", 5, 15],
  ["Belarus", "by", 3, 16],
  ["Belgium", "be", 3, 17],
  ["Belize", "bz", 5, 18],
  ["Benin", "bj", 1, 19],
  ["Bhutan", "bt", 2, 20],
  ["Bolivia", "bo", 7, 21],
  ["Bosnia and Herzegovina", "ba", 3, 22],
  ["Botswana", "bw", 1, 23],
  ["Brazil", "br", 7, 24],
  ["Brunei", "bn", 2, 25],
  ["Bulgaria", "bg", 3, 26],
  ["Burkina Faso", "bf", 1, 27],
  ["Burundi", "bi", 1, 28],
  ["Cabo Verde", "cv", 1, 29],
  ["Cambodia", "kh", 2, 30],
  ["Cameroon", "cm", 1, 31],
  ["Canada", "ca", 5, 32],
  ["Central African Republic", "cf", 1, 33],
  ["Chad", "td", 1, 34],
  ["Chile", "cl", 7, 35],
  ["China", "cn", 1, 36],
  ["Colombia", "co", 7, 37],
  ["Comoros", "km", 1, 38],
  ["Congo", "cg", 1, 39],
  ["Costa Rica", "cr", 5, 40],
  ["Côte d'Ivoire", "ci", 1, 41],
  ["Croatia", "hr", 3, 42],
  ["Cuba", "cu", 5, 43],
  ["Cyprus", "cy", 3, 44],
  ["Czech Republic", "cz", 3, 45],
  ["Democratic People’s Republic of Korea", "kp", 2, 46],
  ["Democratic Republic of the Congo", "cd", 1, 47],
  ["Denmark", "dk", 3, 48],
  ["Djibouti", "dj", 1, 49],
  ["Dominica", "dm", 5, 50],
  ["Dominican Republic", "do", 5, 51],
  ["Ecuador", "ec", 7, 52],
  ["Egypt", "eg", 1, 53],
  ["El Salvador", "sv", 5, 54],
  ["Equatorial Guinea", "gq", 1, 55],
  ["Eritrea", "er", 1, 56],
  ["Estonia", "ee", 3, 57],
  ["Ethiopia", "et", 1, 58],
  ["Federated States of Micronesia", "fm", 6, 59],
  ["Fiji", "fj", 6, 60],
  ["Finland", "fi", 3, 61],
  ["France", "fr", 3, 62],
  ["Gabon", "ga", 1, 63],
  ["Gambia", "gm", 1, 64],
  ["Georgia", "ge", 3, 65],
  ["Germany", "de", 3, 66],
  ["Ghana", "gh", 1, 67],
  ["Greece", "gr", 3, 68],
  ["Grenada", "gd", 5, 69],
  ["Guatemala", "gt", 5, 70],
  ["Guinea", "gn", 1, 71],
  ["Guinea Bissau", "gw", 1, 72],
  ["Guyana", "gy", 7, 73],
  ["Haiti", "ht", 5, 74],
  ["Holy See", "va", 3, 75],
  ["Honduras", "hn", 5, 76],
  ["Hong Kong", "hk", 2, 77],
  ["Hungary", "hu", 3, 78],
  ["Iceland", "is", 3, 79],
  ["India", "in", 2, 80],
  ["Indonesia", "id", 2, 81],
  ["Iran", "ir", 2, 82],
  ["Iraq", "iq", 2, 83],
  ["Ireland", "ie", 3, 84],
  ["Israel", "il", 3, 85],
  ["Italy", "it", 3, 86],
  ["Jamaica", "jm", 5, 87],
  ["Japan", "jp", 2, 88],
  ["Jordan", "jo", 2, 89],
  ["Kazakhstan", "kz", 2, 90],
  ["Kenya", "ke", 1, 91],
  ["Kiribati", "ki", 6, 92],
  ["Republic of Korea", "kr", 2, 93],
  ["Kosovo", "xk", 3, 94],
  ["Kuwait", "kw", 2, 95],
  ["Kyrgyzstan", "kg", 2, 96],
  ["Laos", "la", 2, 97],
  ["Latvia", "lv", 3, 98],
  ["Lebanon", "lb", 2, 99],
  ["Lesotho", "ls", 1, 100],
  ["Liberia", "lr", 1, 101],
  ["Libya", "ly", 1, 102],
  ["Liechtenstein", "li", 3, 103],
  ["Lithuania", "lt", 3, 104],
  ["Luxembourg", "lu", 3, 105],
  ["Macau", "mo", 2, 106],
  ["Macedonia", "mk", 3, 107],
  ["Madagascar", "mg", 1, 108],
  ["Malawi", "mw", 1, 109],
  ["Malaysia", "my", 2, 110],
  ["Maldives", "mv", 2, 111],
  ["Mali", "ml", 1, 112],
  ["Malta", "mt", 3, 113],
  ["Marshall Islands", "mh", 6, 114],
  ["Mauritania", "mr", 1, 115],
  ["Mauritius", "mu", 1, 116],
  ["Mexico", "mx", 5, 117],
  ["Moldova", "md", 3, 118],
  ["Monaco", "mc", 3, 119],
  ["Mongolia", "mn", 2, 120],
  ["Montenegro", "me", 3, 121],
  ["Morocco", "ma", 1, 122],
  ["Mozambique", "mz", 1, 123],
  ["Myanmar", "mm", 2, 124],
  ["Namibia", "na", 1, 125],
  ["Nauru", "nr", 6, 126],
  ["Nepal", "np", 2, 127],
  ["Netherlands", "nl", 3, 128],
  ["New Zealand", "nz", 6, 129],
  ["Nicaragua", "ni", 5, 130],
  ["Niger", "ne", 1, 131],
  ["Nigeria", "ng", 1, 132],
  ["Norway", "no", 3, 133],
  ["Oman", "om", 2, 134],
  ["Pakistan", "pk", 2, 135],
  ["Palau", "pw", 6, 136],
  ["Palestine", "ps", 2, 137],
  ["Panama", "pa", 5, 138],
  ["Papua New Guinea", "pg", 6, 139],
  ["Paraguay", "py", 7, 140],
  ["Peru", "pe", 7, 141],
  ["Philippines", "ph", 2, 142],
  ["Poland", "pl", 3, 143],
  ["Portugal", "pt", 3, 144],
  ["Qatar", "qa", 2, 145],
  ["Romania", "ro", 3, 146],
  ["Russia", "ru", 3, 147],
  ["Rwanda", "rw", 1, 148],
  ["Saint Kitts and Nevis", "kn", 5, 149],
  ["Saint Lucia", "lc", 5, 150],
  ["Saint Vincent and the Grenadines", "vc", 5, 151],
  ["Samoa", "ws", 6, 152],
  ["San Marino", "sm", 3, 153],
  ["São Tomé and Príncipe", "st", 1, 154],
  ["Saudi Arabia", "sa", 2, 155],
  ["Senegal", "sn", 1, 156],
  ["Serbia", "rs", 3, 157],
  ["Seychelles", "sc", 1, 158],
  ["Sierra Leone", "sl", 1, 159],
  ["Singapore", "sg", 2, 160],
  ["Slovakia", "sk", 3, 161],
  ["Slovenia", "si", 3, 162],
  ["Solomon Islands", "sb", 6, 163],
  ["Somalia", "so", 1, 164],
  ["South Africa", "za", 1, 165],
  ["South Sudan", "ss", 1, 166],
  ["Spain", "es", 3, 167],
  ["Sri Lanka", "lk", 2, 168],
  ["Sudan", "sd", 1, 169],
  ["Suriname", "sr", 7, 170],
  ["Swaziland", "sz", 1, 171],
  ["Sweden", "se", 3, 172],
  ["Switzerland", "ch", 3, 173],
  ["Syria", "sy", 2, 174],
  ["Taiwan", "tw", 2, 175],
  ["Tajikistan", "tj", 2, 176],
  ["Tanzania", "tz", 1, 177],
  ["Thailand", "th", 2, 178],
  ["Timor-Leste", "tl", 2, 179],
  ["Togo", "tg", 1, 180],
  ["Tonga", "to", 6, 181],
  ["Trinidad and Tobago", "tt", 5, 182],
  ["Tunisia", "tn", 1, 183],
  ["Turkey", "tr", 3, 184],
  ["Turkmenistan", "tm", 2, 185],
  ["Tuvalu", "tv", 6, 186],
  ["Uganda", "ug", 1, 187],
  ["Ukraine", "ua", 3, 188],
  ["United Arab Emirates", "ae", 2, 189],
  ["United Kingdom", "gb", 3, 190],
  ["Uruguay", "uy", 7, 191],
  ["United States", "us", 5, 192],
  ["Uzbekistan", "uz", 2, 193],
  ["Vanuatu", "vu", 6, 194],
  ["Venezuela", "ve", 7, 195],
  ["Vietnam", "vn", 2, 196],
  ["Multiple Countries (Asia)", "xa", 2, 197],
  ["Multiple Countries (Europe)", "xe", 3, 198],
  ["Multiple Countries (Americas)", "xm", 4, 199],
  ["Multiple Countries (South America)", "xs", 7, 200],
  ["Yemen", "ye", 2, 201],
  ["Zambia", "zm", 1, 202],
  ["Zimbabwe", "zw", 1, 203]
]

Enum.each(round_names, fn [name, id] -> Repo.insert(%RoundName{name: name, id: id}) end)
Enum.each(event_names, fn [name, id] -> Repo.insert(%EventName{name: name, id: id}) end)
Enum.each(continents, fn [name, id] -> Repo.insert(%Continent{name: name, id: id}) end)

Enum.each(countries, fn [name, iso2, continent_id, id] ->
  Repo.insert(%Country{name: name, iso2: iso2, continent_id: continent_id, id: id})
end)

event_name1 = Repo.get(EventName, 1)
event_name2 = Repo.get(EventName, 2)
event_name3 = Repo.get(EventName, 3)
event_name4 = Repo.get(EventName, 4)
event_name5 = Repo.get(EventName, 5)
event_name6 = Repo.get(EventName, 6)

round_name1 = Repo.get(RoundName, 1)
round_name2 = Repo.get(RoundName, 2)
round_name3 = Repo.get(RoundName, 3)
round_name4 = Repo.get(RoundName, 4)
round_name5 = Repo.get(RoundName, 5)
round_name6 = Repo.get(RoundName, 6)

round_names = [round_name1, round_name2, round_name3, round_name4, round_name5]

person1 =
  Repo.insert!(%Person{
    first_name: "John",
    last_name: "Doe",
    wca_id: "2018dupa",
    country_id: 190
  })

person2 =
  Repo.insert!(%Person{
    first_name: "Rafał",
    last_name: "Studnicki",
    wca_id: "1984down",
    country_id: 143
  })

person3 =
  Repo.insert!(%Person{
    first_name: "Kamil",
    last_name: "Zieliński",
    wca_id: "2009lol",
    country_id: 62
  })

country = Repo.get(Country, 141)

tournament = Repo.insert!(%Tournament{name: "Cracow Open 2013", country: country})

# 3x3x3
event1 = Repo.insert!(%Event{event_name: event_name1, tournament: tournament})
# 2x2x2
event2 = Repo.insert!(%Event{event_name: event_name2, tournament: tournament})
# 6x6x6
event3 = Repo.insert!(%Event{event_name: event_name5, tournament: tournament})

# First Round 3x3x3
round1 = Repo.insert!(%Round{round_name: round_name1, event: event1, cutoff: 300, format: "ao5"})
# Second Round 3x3x3
round2 = Repo.insert!(%Round{round_name: round_name2, event: event1, cutoff: nil, format: "ao5"})
# First Round 2x2x2
round3 = Repo.insert!(%Round{round_name: round_name1, event: event2, cutoff: 300, format: "ao5"})
# Second Round 2x2x2
round4 = Repo.insert!(%Round{round_name: round_name2, event: event2, cutoff: nil, format: "ao5"})
# First Round 6x6x6
round5 = Repo.insert!(%Round{round_name: round_name1, event: event3, cutoff: 300, format: "mo3"})
# Second Round 6x6x6
round6 = Repo.insert!(%Round{round_name: round_name2, event: event3, cutoff: nil, format: "mo3"})

Repo.insert(%Result{
  round: round1,
  attempts: [2040, 2480, 2920, 2320, 2960],
  average: 2544,
  competitor_id: person1.id
})

Repo.insert(%Result{
  round: round1,
  attempts: [3240, 2480, 2920, 2320, 2960],
  average: 2784,
  competitor_id: person2.id
})

Repo.insert(%Result{
  round: round1,
  attempts: [2840, 2480, 2320, 2880, 1920],
  average: 2488,
  competitor_id: person3.id
})

Repo.insert(%Result{
  round: round3,
  attempts: [1240, 2480, 2920, 2120, 2960],
  average: 2488,
  competitor_id: person1.id
})

Repo.insert(%Result{
  round: round3,
  attempts: [2840, 2480, 2320, 2880, 1920],
  average: 2344,
  competitor_id: person2.id
})

Repo.insert(%Result{
  round: round3,
  attempts: [1240, 2480, 2920, 2120, 2960],
  average: 2344,
  competitor_id: person3.id
})

Repo.insert(%Result{
  round: round2,
  attempts: [3240, 2480, 2920, 2320, 2960],
  average: 2784,
  competitor_id: person1.id
})

Repo.insert(%Result{
  round: round2,
  attempts: [1240, 2480, 2920, 2120, 2960],
  average: 2784,
  competitor_id: person2.id
})

Repo.insert(%Result{
  round: round2,
  attempts: [3240, 2480, 2920, 2320, 2960],
  average: 2784,
  competitor_id: person3.id
})

Repo.insert(%Result{
  round: round4,
  attempts: [1240, 2480, 2920, 2120, 2960],
  average: 2344,
  competitor_id: person1.id
})

Repo.insert(%Result{
  round: round4,
  attempts: [3240, 2480, 2920, 2320, 2960],
  average: 2344,
  competitor_id: person2.id
})

Repo.insert(%Result{
  round: round4,
  attempts: [1240, 2480, 2920, 2120, 2960],
  average: 2344,
  competitor_id: person3.id
})

Repo.insert(%Result{
  round: round5,
  attempts: [nil, nil, nil],
  average: nil,
  competitor_id: person1.id
})

Repo.insert(%Result{
  round: round5,
  attempts: [nil, nil, nil],
  average: nil,
  competitor_id: person2.id
})

Repo.insert(%Result{
  round: round5,
  attempts: [nil, nil, nil],
  average: nil,
  competitor_id: person3.id
})

Repo.insert(%Result{
  round: round6,
  attempts: [nil, nil, nil],
  average: nil,
  competitor_id: person1.id
})

Repo.insert(%Result{
  round: round6,
  attempts: [nil, nil, nil],
  average: nil,
  competitor_id: person2.id
})

Repo.insert(%Result{
  round: round6,
  attempts: [nil, nil, nil],
  average: nil,
  competitor_id: person3.id
})

[
  810,
  620,
  730,
  580,
  740,
  310,
  620,
  730,
  530,
  740,
  810,
  620,
  730,
  580,
  740,
  310,
  620,
  730,
  530,
  740,
  810,
  620,
  730,
  580,
  740,
  310,
  620,
  730,
  530,
  740
]
