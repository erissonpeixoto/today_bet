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

puts "Criando jogos..."

matches_data = [
  { home_team: "Flamengo",    away_team: "Palmeiras",   league: "Brasileirão Série A", hours_from_now: 2 },
  { home_team: "Real Madrid", away_team: "Barcelona",   league: "La Liga",             hours_from_now: 4 },
  { home_team: "Manchester City", away_team: "Arsenal", league: "Premier League",      hours_from_now: 6 },
  { home_team: "PSG",         away_team: "Lyon",        league: "Ligue 1",             hours_from_now: 8 },
  { home_team: "São Paulo",   away_team: "Corinthians", league: "Brasileirão Série A", hours_from_now: 24 },
  { home_team: "Bayern",      away_team: "Dortmund",    league: "Bundesliga",          hours_from_now: 26 },
]

matches = matches_data.map do |data|
  Match.find_or_create_by!(home_team: data[:home_team], away_team: data[:away_team]) do |m|
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

  # Add some votes to make it interesting
  other_users = users.reject { |u| u == attrs[:user] }
  other_users.first(2).each do |voter|
    Vote.find_or_create_by!(user: voter, tip: tip, vote_type: :concordo)
  end
  if tip.market.in?(%w[over_2_5 ambos_marcam])
    Vote.find_or_create_by!(user: other_users.last, tip: tip, vote_type: :quente)
  end
end

# Recalculate vote counters (since we bypassed callbacks on find_or_create)
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
