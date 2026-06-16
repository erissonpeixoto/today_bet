puts "Criando usuários..."

admin = User.find_or_create_by!(email: "admin@betdodia.com") do |u|
  u.username = "admin"
  u.password = "password123"
  u.admin = true
end

users = [
  { email: "joao@example.com",   username: "joao_bet",    password: "password123" },
  { email: "maria@example.com",  username: "maria_tips",  password: "password123" },
  { email: "carlos@example.com", username: "carlos_fc",   password: "password123" },
  { email: "ana@example.com",    username: "ana_analyst", password: "password123" }
].map do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.username = attrs[:username]
    u.password = attrs[:password]
  end
end

puts "Criando clubes..."

clubs_data = [
  # Brasileirão Série A
  { name: "Flamengo",      logo_url: "https://media.api-sports.io/football/teams/127.png" },
  { name: "Palmeiras",     logo_url: "https://media.api-sports.io/football/teams/121.png" },
  { name: "São Paulo",     logo_url: "https://media.api-sports.io/football/teams/126.png" },
  { name: "Corinthians",   logo_url: "https://media.api-sports.io/football/teams/131.png" },
  { name: "Fluminense",    logo_url: "https://media.api-sports.io/football/teams/124.png" },
  { name: "Grêmio",        logo_url: "https://media.api-sports.io/football/teams/130.png" },
  { name: "Internacional", logo_url: "https://media.api-sports.io/football/teams/119.png" },
  { name: "Atlético-MG",   logo_url: "https://media.api-sports.io/football/teams/1062.png" },
  { name: "Botafogo",      logo_url: "https://media.api-sports.io/football/teams/120.png" },
  { name: "Vasco",         logo_url: "https://media.api-sports.io/football/teams/133.png" },

  # La Liga
  { name: "Real Madrid",       logo_url: "https://media.api-sports.io/football/teams/541.png" },
  { name: "Barcelona",         logo_url: "https://media.api-sports.io/football/teams/529.png" },
  { name: "Atlético Madrid",   logo_url: "https://media.api-sports.io/football/teams/530.png" },
  { name: "Sevilla",           logo_url: "https://media.api-sports.io/football/teams/536.png" },
  { name: "Real Sociedad",     logo_url: "https://media.api-sports.io/football/teams/548.png" },
  { name: "Villarreal",        logo_url: "https://media.api-sports.io/football/teams/533.png" },
  { name: "Athletic Bilbao",   logo_url: "https://media.api-sports.io/football/teams/531.png" },
  { name: "Valencia",          logo_url: "https://media.api-sports.io/football/teams/532.png" },
  { name: "Real Betis",        logo_url: "https://media.api-sports.io/football/teams/543.png" },
  { name: "Celta Vigo",        logo_url: "https://media.api-sports.io/football/teams/538.png" },

  # Premier League
  { name: "Manchester City",   logo_url: "https://media.api-sports.io/football/teams/50.png" },
  { name: "Arsenal",           logo_url: "https://media.api-sports.io/football/teams/42.png" },
  { name: "Liverpool",         logo_url: "https://media.api-sports.io/football/teams/40.png" },
  { name: "Chelsea",           logo_url: "https://media.api-sports.io/football/teams/49.png" },
  { name: "Manchester United", logo_url: "https://media.api-sports.io/football/teams/33.png" },
  { name: "Tottenham",         logo_url: "https://media.api-sports.io/football/teams/47.png" },
  { name: "Newcastle",         logo_url: "https://media.api-sports.io/football/teams/34.png" },
  { name: "Aston Villa",       logo_url: "https://media.api-sports.io/football/teams/66.png" },
  { name: "Brighton",          logo_url: "https://media.api-sports.io/football/teams/51.png" },
  { name: "West Ham",          logo_url: "https://media.api-sports.io/football/teams/48.png" },

  # Bundesliga
  { name: "Bayern",            logo_url: "https://media.api-sports.io/football/teams/157.png" },
  { name: "Dortmund",          logo_url: "https://media.api-sports.io/football/teams/165.png" },
  { name: "RB Leipzig",        logo_url: "https://media.api-sports.io/football/teams/173.png" },
  { name: "Leverkusen",        logo_url: "https://media.api-sports.io/football/teams/168.png" },
  { name: "Frankfurt",         logo_url: "https://media.api-sports.io/football/teams/169.png" },
  { name: "Wolfsburg",         logo_url: "https://media.api-sports.io/football/teams/161.png" },
  { name: "Gladbach",          logo_url: "https://media.api-sports.io/football/teams/163.png" },
  { name: "Union Berlin",      logo_url: "https://media.api-sports.io/football/teams/182.png" },
  { name: "Freiburg",          logo_url: "https://media.api-sports.io/football/teams/160.png" },
  { name: "Hoffenheim",        logo_url: "https://media.api-sports.io/football/teams/167.png" },

  # Ligue 1
  { name: "PSG",               logo_url: "https://media.api-sports.io/football/teams/85.png" },
  { name: "Lyon",              logo_url: "https://media.api-sports.io/football/teams/80.png" },
  { name: "Marseille",         logo_url: "https://media.api-sports.io/football/teams/81.png" },
  { name: "Monaco",            logo_url: "https://media.api-sports.io/football/teams/91.png" },
  { name: "Lille",             logo_url: "https://media.api-sports.io/football/teams/79.png" },
  { name: "Nice",              logo_url: "https://media.api-sports.io/football/teams/84.png" },
  { name: "Rennes",            logo_url: "https://media.api-sports.io/football/teams/94.png" },
  { name: "Lens",              logo_url: "https://media.api-sports.io/football/teams/116.png" },
  { name: "Strasbourg",        logo_url: "https://media.api-sports.io/football/teams/95.png" },
  { name: "Nantes",            logo_url: "https://media.api-sports.io/football/teams/83.png" }
]

clubs = clubs_data.each_with_object({}) do |data, hash|
  club = FootballClub.find_or_create_by!(name: data[:name]) do |c|
    c.logo_url = data[:logo_url]
  end
  hash[data[:name]] = club
end

puts "Criando jogos..."

matches_data = [
  { home: "Flamengo",        away: "Palmeiras",   league: "Brasileirão Série A", hours_from_now: 2 },
  { home: "Real Madrid",     away: "Barcelona",   league: "La Liga",             hours_from_now: 4 },
  { home: "Manchester City", away: "Arsenal",     league: "Premier League",      hours_from_now: 6 },
  { home: "PSG",             away: "Lyon",        league: "Ligue 1",             hours_from_now: 8 },
  { home: "São Paulo",       away: "Corinthians", league: "Brasileirão Série A", hours_from_now: 24 },
  { home: "Bayern",          away: "Dortmund",    league: "Bundesliga",          hours_from_now: 26 }
]

matches = matches_data.map do |data|
  home_club = clubs[data[:home]]
  away_club = clubs[data[:away]]
  Match.find_or_create_by!(home_club: home_club, away_club: away_club) do |m|
    m.league = data[:league]
    m.match_date = data[:hours_from_now].hours.from_now
    m.status = :scheduled
  end
end

puts "Criando palpites de exemplo..."

sample_tips = [
  {
    match: matches[0], user: users[0],
    market: :over_2_5, confidence: :alta,
    justification: "Flamengo tem a melhor ofensiva do campeonato e o Palmeiras vem de defesa desfalcada. Últimos 5 H2H tiveram média de 3.2 gols. Gramado do Maracanã favorece o ataque."
  },
  {
    match: matches[0], user: users[1],
    market: :ambos_marcam, confidence: :media,
    justification: "Palmeiras tem atacantes letais mesmo fora de casa. Flamengo defende mal em transições. Ambas as equipes marcaram nos últimos 4 confrontos diretos."
  },
  {
    match: matches[0], user: users[2],
    market: :vitoria_mandante, confidence: :alta,
    justification: "Flamengo em casa é brutal. 8 vitórias seguidas no Maracanã, com Gabriel e Pedro em grande fase. Palmeiras perde 2 titulares por suspensão."
  },
  {
    match: matches[1], user: users[0],
    market: :over_2_5, confidence: :alta,
    justification: "El Clásico nunca decepciona. Média de 4.1 gols nos últimos 6 confrontos. Mbappé vs Yamal vai gerar duelos individuais que produzem gols."
  },
  {
    match: matches[1], user: users[3],
    market: :ambos_marcam, confidence: :alta,
    justification: "Barcelona marca em todos os jogos em casa na temporada. Real Madrid nunca ficou sem marcar no Clásico nos últimos 3 anos. Cota excelente."
  }
]

sample_tips.each do |attrs|
  tip = Tip.find_or_create_by!(
    match: attrs[:match], user: attrs[:user], market: attrs[:market]
  ) do |t|
    t.confidence = attrs[:confidence]
    t.justification = attrs[:justification]
  end

  other_users = users.reject { |u| u == attrs[:user] }
  other_users.first(2).each do |voter|
    Vote.find_or_create_by!(user: voter, tip: tip, vote_type: :concordo)
  end
  if tip.market.in?(%w[over_2_5 ambos_marcam])
    Vote.find_or_create_by!(user: other_users.last, tip: tip, vote_type: :quente)
  end
end

Tip.find_each do |tip|
  tip.update_columns(
    votes_agree_count:    tip.votes.concordo.count,
    votes_disagree_count: tip.votes.discordo.count,
    votes_hot_count:      tip.votes.quente.count,
    comments_count:       tip.comments.count
  )
end

puts "Criando seleções da Copa 2026..."

puts "Criando seleções da Copa 2026..."

cup_teams_data = [
  # UEFA — IDs confirmados onde disponível
  { name: "Alemanha",        logo_url: "https://media.api-sports.io/football/teams/25.png"    },
  { name: "França",          logo_url: "https://media.api-sports.io/football/teams/2.png"     },
  { name: "Espanha",         logo_url: "https://media.api-sports.io/football/teams/9.png"     },
  { name: "Inglaterra",      logo_url: "https://media.api-sports.io/football/teams/10.png"    },
  { name: "Portugal",        logo_url: "https://media.api-sports.io/football/teams/27.png"    },
  { name: "Holanda",         logo_url: "https://media.api-sports.io/football/teams/1118.png"  },
  { name: "Bélgica",         logo_url: "https://media.api-sports.io/football/teams/1.png"     },
  { name: "Croácia",         logo_url: "https://media.api-sports.io/football/teams/3.png"     },
  { name: "Suíça",           logo_url: "https://media.api-sports.io/football/teams/15.png"    },
  { name: "Áustria",         logo_url: "https://media.api-sports.io/football/teams/775.png"   },
  { name: "Escócia",         logo_url: "https://media.api-sports.io/football/teams/1108.png"  },
  { name: "Turquia",         logo_url: "https://media.api-sports.io/football/teams/777.png"   },
  { name: "República Tcheca", logo_url: "https://media.api-sports.io/football/teams/770.png"   },
  { name: "Bósnia",          logo_url: "https://media.api-sports.io/football/teams/1113.png"  },
  { name: "Suécia",          logo_url: "https://media.api-sports.io/football/teams/5.png"     },
  { name: "Noruega",         logo_url: "https://media.api-sports.io/football/teams/1090.png"  },

  # CONMEBOL
  { name: "Brasil",          logo_url: "https://media.api-sports.io/football/teams/6.png"     },
  { name: "Argentina",       logo_url: "https://media.api-sports.io/football/teams/26.png"    },
  { name: "Colômbia",        logo_url: "https://media.api-sports.io/football/teams/8.png"     },
  { name: "Uruguai",         logo_url: "https://media.api-sports.io/football/teams/7.png"     },
  { name: "Equador",         logo_url: "https://media.api-sports.io/football/teams/2382.png"  },
  { name: "Paraguai",        logo_url: "https://media.api-sports.io/football/teams/2380.png"  },

  # CONCACAF
  { name: "Estados Unidos",  logo_url: "https://media.api-sports.io/football/teams/2384.png"  },
  { name: "México",          logo_url: "https://media.api-sports.io/football/teams/16.png"    },
  { name: "Canadá",          logo_url: "https://media.api-sports.io/football/teams/5529.png"  },
  { name: "Panamá",          logo_url: "https://media.api-sports.io/football/teams/11.png"    },
  { name: "Haiti",           logo_url: "https://media.api-sports.io/football/teams/2386.png"  },
  { name: "Curaçao",         logo_url: "https://media.api-sports.io/football/teams/5530.png"  },

  # CAF
  { name: "Marrocos",        logo_url: "https://media.api-sports.io/football/teams/31.png"    },
  { name: "Senegal",         logo_url: "https://media.api-sports.io/football/teams/13.png"    },
  { name: "Egito",           logo_url: "https://media.api-sports.io/football/teams/32.png"    },
  { name: "Costa do Marfim", logo_url: "https://media.api-sports.io/football/teams/1501.png"  },
  { name: "África do Sul",   logo_url: "https://media.api-sports.io/football/teams/1531.png"  },
  { name: "Argélia",         logo_url: "https://media.api-sports.io/football/teams/1532.png"  },
  { name: "Gana",            logo_url: "https://media.api-sports.io/football/teams/1504.png"  },
  { name: "RD Congo",        logo_url: "https://media.api-sports.io/football/teams/1517.png"  },
  { name: "Cabo Verde",      logo_url: "https://media.api-sports.io/football/teams/1533.png"  },
  { name: "Tunísia",         logo_url: "https://media.api-sports.io/football/teams/28.png"    },

  # AFC
  { name: "Japão",           logo_url: "https://media.api-sports.io/football/teams/12.png"    },
  { name: "Coreia do Sul",   logo_url: "https://media.api-sports.io/football/teams/17.png"    },
  { name: "Arábia Saudita",  logo_url: "https://media.api-sports.io/football/teams/23.png"    },
  { name: "Irã",             logo_url: "https://media.api-sports.io/football/teams/22.png"    },
  { name: "Austrália",       logo_url: "https://media.api-sports.io/football/teams/20.png"    },
  { name: "Catar",           logo_url: "https://media.api-sports.io/football/teams/1569.png"  },
  { name: "Jordânia",        logo_url: "https://media.api-sports.io/football/teams/1548.png"  },
  { name: "Uzbequistão",     logo_url: "https://media.api-sports.io/football/teams/1568.png"  },

  # OFC
  { name: "Nova Zelândia",   logo_url: "https://media.api-sports.io/football/teams/4673.png"  },

  # Repescagem intercontinental
  { name: "Iraque",          logo_url: "https://media.api-sports.io/football/teams/1567.png" }
]

cup_clubs = cup_teams_data.each_with_object({}) do |data, hash|
  club = FootballClub.find_or_create_by!(name: data[:name]) do |c|
    c.logo_url = data[:logo_url]
  end
  hash[data[:name]] = club
end

puts "Criando partidas da Copa 2026 (fase de grupos)..."
CupMatch.where(phase: :group_stage).destroy_all

brt = "-03:00"
cup_matches_schedule = [
  # GRUPO A
  { home: "México",         away: "África do Sul",    group: "Grupo A", date: Time.new(2026, 6, 11, 16, 0, 0, brt), venue: "Estadio Azteca, Cidade do México" },
  { home: "Coreia do Sul",  away: "República Tcheca", group: "Grupo A", date: Time.new(2026, 6, 11, 23, 0, 0, brt), venue: "Estadio AKRON, Guadalajara" },
  { home: "México",         away: "Coreia do Sul",    group: "Grupo A", date: Time.new(2026, 6, 18, 13, 0, 0, brt), venue: "Estadio Azteca, Cidade do México" },
  { home: "África do Sul",  away: "República Tcheca", group: "Grupo A", date: Time.new(2026, 6, 18, 22, 0, 0, brt), venue: "Estadio AKRON, Guadalajara" },
  { home: "México",         away: "República Tcheca", group: "Grupo A", date: Time.new(2026, 6, 24, 22, 0, 0, brt), venue: "AT&T Stadium, Dallas" },
  { home: "Coreia do Sul",  away: "África do Sul",    group: "Grupo A", date: Time.new(2026, 6, 24, 22, 0, 0, brt), venue: "Levi's Stadium, San Francisco" },

  # GRUPO B
  { home: "Canadá",  away: "Bósnia",   group: "Grupo B", date: Time.new(2026, 6, 12, 16, 0, 0, brt), venue: "BMO Field, Toronto" },
  { home: "Catar",   away: "Suíça",    group: "Grupo B", date: Time.new(2026, 6, 13, 16, 0, 0, brt), venue: "Hard Rock Stadium, Miami" },
  { home: "Canadá",  away: "Catar",    group: "Grupo B", date: Time.new(2026, 6, 18, 16, 0, 0, brt), venue: "BMO Field, Toronto" },
  { home: "Bósnia",  away: "Suíça",    group: "Grupo B", date: Time.new(2026, 6, 18, 19, 0, 0, brt), venue: "MetLife Stadium, New Jersey" },
  { home: "Canadá",  away: "Suíça",    group: "Grupo B", date: Time.new(2026, 6, 24, 16, 0, 0, brt), venue: "BC Place, Vancouver" },
  { home: "Bósnia",  away: "Catar",    group: "Grupo B", date: Time.new(2026, 6, 24, 16, 0, 0, brt), venue: "Hard Rock Stadium, Miami" },

  # GRUPO C
  { home: "Brasil",   away: "Marrocos", group: "Grupo C", date: Time.new(2026, 6, 13, 19, 0, 0, brt), venue: "MetLife Stadium, New Jersey" },
  { home: "Haiti",    away: "Escócia",  group: "Grupo C", date: Time.new(2026, 6, 13, 22, 0, 0, brt), venue: "AT&T Stadium, Dallas" },
  { home: "Brasil",   away: "Haiti",    group: "Grupo C", date: Time.new(2026, 6, 19, 19, 0, 0, brt), venue: "SoFi Stadium, Los Angeles" },
  { home: "Marrocos", away: "Escócia",  group: "Grupo C", date: Time.new(2026, 6, 19, 22, 0, 0, brt), venue: "Empower Field, Denver" },
  { home: "Brasil",   away: "Escócia",  group: "Grupo C", date: Time.new(2026, 6, 24, 19, 0, 0, brt), venue: "Arrowhead Stadium, Kansas City" },
  { home: "Haiti",    away: "Marrocos", group: "Grupo C", date: Time.new(2026, 6, 24, 19, 0, 0, brt), venue: "Lincoln Financial Field, Philadelphia" },

  # GRUPO D
  { home: "Estados Unidos", away: "Paraguai",   group: "Grupo D", date: Time.new(2026, 6, 12, 22, 0, 0, brt), venue: "Rose Bowl, Los Angeles" },
  { home: "Austrália",      away: "Turquia",    group: "Grupo D", date: Time.new(2026, 6, 13,  1, 0, 0, brt), venue: "Arrowhead Stadium, Kansas City" },
  { home: "Estados Unidos", away: "Austrália",  group: "Grupo D", date: Time.new(2026, 6, 19,  1, 0, 0, brt), venue: "Levi's Stadium, San Francisco" },
  { home: "Paraguai",       away: "Turquia",    group: "Grupo D", date: Time.new(2026, 6, 19, 16, 0, 0, brt), venue: "AT&T Stadium, Dallas" },
  { home: "Estados Unidos", away: "Turquia",    group: "Grupo D", date: Time.new(2026, 6, 25, 23, 0, 0, brt), venue: "MetLife Stadium, New Jersey" },
  { home: "Austrália",      away: "Paraguai",   group: "Grupo D", date: Time.new(2026, 6, 25, 23, 0, 0, brt), venue: "Hard Rock Stadium, Miami" },

  # GRUPO E
  { home: "Alemanha",        away: "Curaçao",         group: "Grupo E", date: Time.new(2026, 6, 14, 14, 0, 0, brt), venue: "MetLife Stadium, New Jersey" },
  { home: "Costa do Marfim", away: "Equador",          group: "Grupo E", date: Time.new(2026, 6, 14, 20, 0, 0, brt), venue: "Lumen Field, Seattle" },
  { home: "Alemanha",        away: "Costa do Marfim",  group: "Grupo E", date: Time.new(2026, 6, 20, 17, 0, 0, brt), venue: "AT&T Stadium, Dallas" },
  { home: "Curaçao",         away: "Equador",          group: "Grupo E", date: Time.new(2026, 6, 20, 21, 0, 0, brt), venue: "Rose Bowl, Los Angeles" },
  { home: "Alemanha",        away: "Equador",          group: "Grupo E", date: Time.new(2026, 6, 25, 17, 0, 0, brt), venue: "Lincoln Financial Field, Philadelphia" },
  { home: "Costa do Marfim", away: "Curaçao",          group: "Grupo E", date: Time.new(2026, 6, 25, 17, 0, 0, brt), venue: "BC Place, Vancouver" },

  # GRUPO F
  { home: "Holanda", away: "Japão",   group: "Grupo F", date: Time.new(2026, 6, 14, 17, 0, 0, brt), venue: "Levi's Stadium, San Francisco" },
  { home: "Suécia",  away: "Tunísia", group: "Grupo F", date: Time.new(2026, 6, 14, 23, 0, 0, brt), venue: "Arrowhead Stadium, Kansas City" },
  { home: "Holanda", away: "Suécia",  group: "Grupo F", date: Time.new(2026, 6, 20, 14, 0, 0, brt), venue: "Hard Rock Stadium, Miami" },
  { home: "Japão",   away: "Tunísia", group: "Grupo F", date: Time.new(2026, 6, 21,  1, 0, 0, brt), venue: "SoFi Stadium, Los Angeles" },
  { home: "Holanda", away: "Tunísia", group: "Grupo F", date: Time.new(2026, 6, 25, 20, 0, 0, brt), venue: "Empower Field, Denver" },
  { home: "Japão",   away: "Suécia",  group: "Grupo F", date: Time.new(2026, 6, 25, 20, 0, 0, brt), venue: "Lumen Field, Seattle" },

  # GRUPO G
  { home: "Bélgica",       away: "Egito",         group: "Grupo G", date: Time.new(2026, 6, 15, 16, 0, 0, brt), venue: "Lincoln Financial Field, Philadelphia" },
  { home: "Irã",           away: "Nova Zelândia",  group: "Grupo G", date: Time.new(2026, 6, 15, 22, 0, 0, brt), venue: "Lumen Field, Seattle" },
  { home: "Bélgica",       away: "Irã",            group: "Grupo G", date: Time.new(2026, 6, 21, 16, 0, 0, brt), venue: "Hard Rock Stadium, Miami" },
  { home: "Egito",         away: "Nova Zelândia",  group: "Grupo G", date: Time.new(2026, 6, 21, 22, 0, 0, brt), venue: "Rose Bowl, Los Angeles" },
  { home: "Bélgica",       away: "Nova Zelândia",  group: "Grupo G", date: Time.new(2026, 6, 27,  0, 0, 0, brt), venue: "Empower Field, Denver" },
  { home: "Egito",         away: "Irã",            group: "Grupo G", date: Time.new(2026, 6, 27,  0, 0, 0, brt), venue: "BMO Field, Toronto" },

  # GRUPO H
  { home: "Espanha",       away: "Cabo Verde",    group: "Grupo H", date: Time.new(2026, 6, 15, 13, 0, 0, brt), venue: "MetLife Stadium, New Jersey" },
  { home: "Arábia Saudita", away: "Uruguai",      group: "Grupo H", date: Time.new(2026, 6, 15, 19, 0, 0, brt), venue: "Arrowhead Stadium, Kansas City" },
  { home: "Espanha",       away: "Arábia Saudita", group: "Grupo H", date: Time.new(2026, 6, 21, 13, 0, 0, brt), venue: "AT&T Stadium, Dallas" },
  { home: "Cabo Verde",    away: "Uruguai",        group: "Grupo H", date: Time.new(2026, 6, 21, 19, 0, 0, brt), venue: "BC Place, Vancouver" },
  { home: "Espanha",       away: "Uruguai",        group: "Grupo H", date: Time.new(2026, 6, 26, 21, 0, 0, brt), venue: "SoFi Stadium, Los Angeles" },
  { home: "Cabo Verde",    away: "Arábia Saudita", group: "Grupo H", date: Time.new(2026, 6, 26, 21, 0, 0, brt), venue: "Lumen Field, Seattle" },

  # GRUPO I
  { home: "França",   away: "Senegal", group: "Grupo I", date: Time.new(2026, 6, 16, 16, 0, 0, brt), venue: "AT&T Stadium, Dallas" },
  { home: "Iraque",   away: "Noruega", group: "Grupo I", date: Time.new(2026, 6, 16, 19, 0, 0, brt), venue: "Empower Field, Denver" },
  { home: "França",   away: "Iraque",  group: "Grupo I", date: Time.new(2026, 6, 22, 18, 0, 0, brt), venue: "Rose Bowl, Los Angeles" },
  { home: "Senegal",  away: "Noruega", group: "Grupo I", date: Time.new(2026, 6, 22, 21, 0, 0, brt), venue: "Lincoln Financial Field, Philadelphia" },
  { home: "França",   away: "Noruega", group: "Grupo I", date: Time.new(2026, 6, 26, 16, 0, 0, brt), venue: "MetLife Stadium, New Jersey" },
  { home: "Iraque",   away: "Senegal", group: "Grupo I", date: Time.new(2026, 6, 26, 16, 0, 0, brt), venue: "Arrowhead Stadium, Kansas City" },

  # GRUPO J
  { home: "Argentina", away: "Argélia", group: "Grupo J", date: Time.new(2026, 6, 16, 22, 0, 0, brt), venue: "MetLife Stadium, New Jersey" },
  { home: "Áustria",   away: "Jordânia", group: "Grupo J", date: Time.new(2026, 6, 17,  1, 0, 0, brt), venue: "Levi's Stadium, San Francisco" },
  { home: "Argentina", away: "Áustria",  group: "Grupo J", date: Time.new(2026, 6, 22, 14, 0, 0, brt), venue: "Hard Rock Stadium, Miami" },
  { home: "Argélia",   away: "Jordânia", group: "Grupo J", date: Time.new(2026, 6, 23,  0, 0, 0, brt), venue: "BC Place, Vancouver" },
  { home: "Argentina", away: "Jordânia", group: "Grupo J", date: Time.new(2026, 6, 27, 23, 0, 0, brt), venue: "SoFi Stadium, Los Angeles" },
  { home: "Argélia",   away: "Áustria",  group: "Grupo J", date: Time.new(2026, 6, 27, 23, 0, 0, brt), venue: "BMO Field, Toronto" },

  # GRUPO K
  { home: "Portugal",    away: "RD Congo",    group: "Grupo K", date: Time.new(2026, 6, 17, 14, 0, 0, brt), venue: "SoFi Stadium, Los Angeles" },
  { home: "Uzbequistão", away: "Colômbia",    group: "Grupo K", date: Time.new(2026, 6, 17, 23, 0, 0, brt), venue: "Levi's Stadium, San Francisco" },
  { home: "Portugal",    away: "Uzbequistão", group: "Grupo K", date: Time.new(2026, 6, 23, 14, 0, 0, brt), venue: "Rose Bowl, Los Angeles" },
  { home: "RD Congo",    away: "Colômbia",    group: "Grupo K", date: Time.new(2026, 6, 23, 23, 0, 0, brt), venue: "Empower Field, Denver" },
  { home: "Portugal",    away: "Colômbia",    group: "Grupo K", date: Time.new(2026, 6, 27, 20, 30, 0, brt), venue: "AT&T Stadium, Dallas" },
  { home: "RD Congo",    away: "Uzbequistão", group: "Grupo K", date: Time.new(2026, 6, 27, 20, 30, 0, brt), venue: "Arrowhead Stadium, Kansas City" },

  # GRUPO L
  { home: "Inglaterra", away: "Croácia", group: "Grupo L", date: Time.new(2026, 6, 17, 17, 0, 0, brt), venue: "Hard Rock Stadium, Miami" },
  { home: "Gana",       away: "Panamá",  group: "Grupo L", date: Time.new(2026, 6, 17, 20, 0, 0, brt), venue: "Lincoln Financial Field, Philadelphia" },
  { home: "Inglaterra", away: "Gana",    group: "Grupo L", date: Time.new(2026, 6, 23, 17, 0, 0, brt), venue: "MetLife Stadium, New Jersey" },
  { home: "Croácia",    away: "Panamá",  group: "Grupo L", date: Time.new(2026, 6, 23, 20, 0, 0, brt), venue: "Lumen Field, Seattle" },
  { home: "Inglaterra", away: "Panamá",  group: "Grupo L", date: Time.new(2026, 6, 27, 18, 0, 0, brt), venue: "BC Place, Vancouver" },
  { home: "Croácia",    away: "Gana",    group: "Grupo L", date: Time.new(2026, 6, 27, 18, 0, 0, brt), venue: "BMO Field, Toronto" }
].freeze

cup_matches_schedule.each do |data|
  home = cup_clubs[data[:home]]
  away = cup_clubs[data[:away]]
  unless home && away
    puts "  AVISO: seleção não encontrada — #{data[:home]} ou #{data[:away]}"
    next
  end
  CupMatch.find_or_create_by!(
    home_club:  home,
    away_club:  away,
    phase:      :group_stage,
    match_date: data[:date]
  ) do |m|
    m.group_name = data[:group]
    m.venue      = data[:venue]
    m.status     = :scheduled
  end
end

puts "Seeds criados com sucesso!"
puts "Admin: admin@betdodia.com / password123"
puts "User:  joao@example.com / password123"
puts "Copa 2026: #{CupMatch.count} partidas de grupo | #{cup_teams_data.size} seleções"
