
module Entities
  class KloutAccount < Base 
    include TenantAndProjectScoped
  end
end