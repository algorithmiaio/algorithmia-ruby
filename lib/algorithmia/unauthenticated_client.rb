module Algorithmia
  class UnauthenticatedClient < Client
    def initialize
      super(nil)
    end
  end
end
