class Team < ApplicationRecord
  enum league: { central: 0, pacific: 1}
end
