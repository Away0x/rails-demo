module BlackCandyError
  class Forbidden < StandardError; end
  class NotFound < StandardError; end
  class InvalidFilePath < StandardError; end
end