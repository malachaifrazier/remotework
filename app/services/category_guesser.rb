class CategoryGuesser
  def self.guess_category_from_title(title)
    # Some boards don't have any type of category on their job postings (yuck!). We've gotta
    # make a guess based on keywords the job title (yuck).  Order in the array is important
    # here - you want "Software Engineer Manager" to end up in management, not development.
    # Likewise you *probably* want "Public Relations Management" to be in other, not
    # management.
    all_keywords = [
      [ ['devops','sales','payroll','counsel','public relations','accountant','controller','tax','system administrator','writer','database'], 'other' ],
      [ ['manager','director','scrum','vp'], 'management' ],
      [ ['engineer','engineers','developer','developers','architect','programmer','programmers','dev'], 'development' ],
      [ ['designer','ux','ui','creative'], 'design' ]
    ]

    all_keywords.each do |keyword_map|
      keywords = keyword_map.first
      category = keyword_map.last
      clean_title_words = title.downcase.gsub(/[^a-z\s\-]/, '').gsub('-',' ').split(' ')
      return category if ! (clean_title_words & keywords).empty?
    end
    'other'
  end
end
