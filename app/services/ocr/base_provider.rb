# Base OCR Provider Interface
# All OCR providers must inherit from this class and implement the extract method
module Ocr
  class BaseProvider
    # Extract text from a PDF file
    # @param pdf_file [ActiveStorage::Blob] The PDF file to process
    # @return [Hash] Result hash with :success, :text, :page_count, :error (optional)
    def extract(pdf_file)
      raise NotImplementedError, "#{self.class.name} must implement #extract method"
    end
    
    protected
    
    # Download the PDF file to a temporary location for processing
    # @param pdf_file [ActiveStorage::Blob] The PDF file
    # @return [String] Path to temporary file
    def download_pdf(pdf_file)
      tempfile = Tempfile.new(['contract', '.pdf'])
      tempfile.binmode
      pdf_file.download { |chunk| tempfile.write(chunk) }
      tempfile.rewind
      tempfile.path
    ensure
      tempfile&.close
    end
  end
end
