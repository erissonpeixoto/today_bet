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
  { email: "ana@example.com",    username: "ana_analyst", password: "password123" },
].map do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.username = attrs[:username]
    u.password = attrs[:password]
  end
end

puts "Criando clubes..."

clubs_data = [
  # Brasileirão Série A
  { name: "Flamengo",          logo_url: "https://media.api-sports.io/football/teams/127.png" },
  { name: "Palmeiras",         logo_url: "https://media.api-sports.io/football/teams/121.png" },
  { name: "São Paulo",         logo_url: "https://media.api-sports.io/football/teams/126.png" },
  { name: "Corinthians",       logo_url: "https://media.api-sports.io/football/teams/131.png" },
  { name: "Fluminense",        logo_url: "https://media.api-sports.io/football/teams/119.png" },
  { name: "Grêmio",            logo_url: "https://media.api-sports.io/football/teams/118.png" },
  { name: "Internacional",     logo_url: "https://media.api-sports.io/football/teams/120.png" },
  { name: "Atlético-MG",       logo_url: "https://media.api-sports.io/football/teams/1062.png" },
  { name: "Botafogo",          logo_url: "https://media.api-sports.io/football/teams/117.png" },
  { name: "Vasco",             logo_url: "https://media.api-sports.io/football/teams/133.png" },

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
  { name: "Nantes",            logo_url: "https://media.api-sports.io/football/teams/83.png" },
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
  { home: "Bayern",          away: "Dortmund",    league: "Bundesliga",          hours_from_now: 26 },
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
  },
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

puts "Seeds criados com sucesso!"
puts "Admin: admin@betdodia.com / password123"
puts "User:  joao@example.com / password123"
