namespace :schedule do
  desc "create schedule records for season"
  task :import => :environment do
    data = [
        # 6-th tour
        {tour_id: 592,
         date: '2016-10-22',
         leagues:
          [
              # senior
              {league_id: 584,
               matches:
                   [
                       [205, 151], [221, 7], [18, 13], [11, 15], [235, 210]
                   ]
              },
              # middle
              {league_id: 585,
               matches:
                   [
                       [3, 226], [208, 215], [233, 227], [223, 212]
                   ]
              },
              # junior
              {league_id: 586,
               matches:
                   [
                       [10, 238], [237, 8], [229, 219], [236, 232]
                   ]
              }
          ]
        },
        # 7-th tour
        {tour_id: 593,
         date: '2016-10-29',
         leagues:
             [
                 # senior
                 {league_id: 584,
                  matches:
                      [
                          [15, 13], [221, 151], [11, 7], [205, 235], [18, 210]
                      ]
                 },
                 # middle
                 {league_id: 585,
                  matches:
                      [
                          [227, 215], [234, 226], [233, 230], [3, 223], [208, 212]
                      ]
                 },
                 # junior
                 {league_id: 586,
                  matches:
                      [
                          [219, 8], [214, 238], [10, 236], [237, 232]
                      ]
                 }
             ]
        },
        # # 8-th tour
        {tour_id: 594,
         date: '2016-11-05',
         leagues:
             [
                 # senior
                 {league_id: 584,
                  matches:
                      [
                          [235, 15], [7, 13], [221, 210], [11, 151], [18, 205]
                      ]
                 },
                 # middle
                 {league_id: 585,
                  matches:
                      [
                          [223, 227], [230, 215], [234, 212], [233, 226], [208, 3]
                      ]
                 },
                 # junior
                 {league_id: 586,
                  matches:
                      [
                          [236, 219], [214, 232], [229, 238], [237, 10]
                      ]
                 }
             ]
        },
        # # 9-th tour
        {tour_id: 595,
         date: '2016-11-12',
         leagues:
             [
                 # senior
                 {league_id: 584,
                  matches:
                      [
                          [210, 151], [13, 11], [205, 15], [235, 7], [221, 18]
                      ]
                 },
                 # middle
                 {league_id: 585,
                  matches:
                      [
                          [212, 226], [215, 233], [3, 227], [223, 230], [234, 208]
                      ]
                 },
                 # junior
                 {league_id: 586,
                  matches:
                      [
                          [232, 238], [8, 229], [10, 219], [214, 237]
                      ]
                 }
             ]
        },
    ]

    data.each do |tour|
      tour[:leagues].each do |league|
        league[:matches].each do |game|
          params = {match_on: tour[:date], match_at: '00:00', host_team_id: game[0], guest_team_id: game[1],
                    tour_id: tour[:tour_id], league_id: league[:league_id], venue_id: 16}
          schedule = Schedule.new(params)
          schedule.save
          # puts "Valid" if schedule.valid?
        end
      end
    end
  end

end