require 'pdf-reader'

# PDF Reader Provider - FREE text extraction from digital PDFs
# Uses the pdf-reader gem to extract text from PDFs that were digitally created
# Works for ~80-90% of contracts (those created from Word, software, etc.)
# Does NOT work for scanned/image-based PDFs
module Ocr
  class PdfReaderProvider < BaseProvider
    def extract(pdf_file)
      pdf_path = download_pdf(pdf_file)
      
      reader = PDF::Reader.new(pdf_path)
      page_count = reader.page_count
      
      # Extract text from all pages
      text = reader.pages.map do |page|
        page.text.strip
      end.join("\n\n")
      
      # Clean up extracted text
      text = clean_text(text)
      
      {
        success: true,
        text: text,
        page_count: page_count,
        error: nil
      }
    rescue PDF::Reader::MalformedPDFError => e
      {
        success: false,
        text: nil,
        page_count: 0,
        error: "PDF is malformed or corrupted: #{e.message}"
      }
    rescue PDF::Reader::UnsupportedFeatureError => e
      {
        success: false,
        text: nil,
        page_count: 0,
        error: "PDF contains unsupported features (may be scanned/image-based): #{e.message}"
      }
    rescue => e
      {
        success: false,
        text: nil,
        page_count: 0,
        error: "Failed to extract text from PDF: #{e.message}"
      }
    ensure
      # Clean up temporary file
      File.delete(pdf_path) if pdf_path && File.exist?(pdf_path)
    end
    
    private
    
    # Clean and normalize extracted text
    def clean_text(text)
      return "" if text.blank?
      
      # Remove excessive whitespace
      text = text.gsub(/\s+/, ' ')
      
      # Normalize line breaks
      text = text.gsub(/\n{3,}/, "\n\n")
      
      # Remove null bytes and control characters
      text = text.tr("\u0000", "")
      
      # Trim whitespace
      text.strip
    end
  end
end
