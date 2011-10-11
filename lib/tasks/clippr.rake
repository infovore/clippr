namespace :clippr do
  desc "Generate slugs and displaynames for all initial books."
  task :backfill_book_slugs => :environment do
    Book.all.each do |book|
      book.display_name = book.title
      book.save
    end
  end
end
