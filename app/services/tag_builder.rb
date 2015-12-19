# A lot of this *could* be moved into the database to make it more 
# configurable, but that's probably overkill for now.
#
class TagBuilder
  CATEGORY_TAGS = %w[development design management other]

  LANGUAGE_TAGS = %w[java javascript coffeescript ecmascript c ruby python golang php c-plus-plus typescript actionscript objective-c swift css sass
                   scss less sql groovy haskell clojure scala erlang vb lisp r fortran pascal delphi kotlin ceylon html bash f ocaml perl
                   xml json elixir lua assembly-language matlab cobol d ada dart rust smalltalk tcl]

  LIBRARY_TAGS = %w[ruby-on-rails sinatra grape cake drupal joomla symfony zend wordpress magneto laravel flask django node angular backbone
                  ember spring cocoa ios iphone lift android titanium xamarin hibernate jpa jee extjs mfc appkit react flux gwt opengl
                  entity-framework activesync instagram bootstrap cordova sequel dojo rabbitmq sensu jquery ionic lucene d3 play-framework
                  tapestry canjs asp]

  TOOL_TAGS = %w[puppet chef linux mysql postgresql openstack azure svn maven npm git visual-studio syslog tcp-ip apache lamp unix ansible
               salt ubuntu oracle sybase sql-server ghc vagrant rackspace aws ec2 redis mongodb neo4j heroku solr elasticsearch etl
               confluence hbase xcode powershell s3 xen nagios debian jenkins psd openvswitch selenium gulp grunt bower tomcat
               jetty map-reduce capistrano rabbitmq zeromq bitcoin cassandra twilio docker coreos rhel osgi hadoop ajax sqs bsd mesos
               sitecore sharepoint highrise iis]

  SKILL_TAGS = %w[agile sales human-resources copywriting devops system-administration architecture exchange cryptography security
               user-interface user-experience multithreading network scalability cloud documentation rest saas kernel computer-vision
               augmented-reality analytics project-management product-management pair-programming big-data mobile responsive-design
               microservices scrum support qa data-modeling tdd front-end mean mean-stack soa soap corba contract freelance
               mailchimp marketing recruiting social-media internship e-commerce]

  SYNONYMS_WITH_SPACES = {
    'sql server' => 'sql-server',
    'ruby on rails' => 'ruby-on-rails',
  }

  SYNONYMS = {
    'c-sharp' => 'c#',
    'c++' => 'c-plus-plus',
    'c99' => 'c',
    'c-99' => 'c',
    'c/c++' => 'c c-plus-plus',
    'objc' => 'objective-c',
    'obj-c' => 'objective-c',
    'pl/sql' => 'sql',
    't-sql' => 'sql',
    'vb.net' => 'vb',
    'html5' => 'html',
    'css3' => 'css',
    'es5' => 'ecmascript',
    'es6' => 'ecmascript',
    'js' => 'javascript',
    'ecmascript-6' => 'ecmascript',
    'bigdata' => 'big-data',
    'amazon-web-services' => 'aws',
    'j2ee' => 'jee',
    'java-ee' => 'jee',
    'rhel5' => 'rhel',
    'rhel6' => 'rhel',
    'rhel7' => 'rhel',
    'mssql' => 'sql-server',
    'postgres' => 'postgresql',
    'rails' => 'ruby-on-rails',
    'frontend' => 'front-end',
    'nodejs' => 'node',
    'angularjs' => 'angular',
    'emberjs' => 'ember',
    'reactjs' => 'react',
    'react.js' => 'react',
    'selenium-webdriver' => 'selenium',
    'd3.js' => 'd3',
    'technical-support' => 'support',
    'customer-support' => 'support',
    'customer-care' => 'support',
    'swift2' => 'swift',
    'angular2' => 'angular',
    'ruby on rails' => 'ruby-on-rails',
    'recruiter' => 'recruiting',
    'node.js' => 'node',
    'intern' => 'internship',
    'django-rest-framework' => 'django',
    'restful' => 'rest',
  }

  def initialize(category, title, description, other='')
    @title = replace_synonyms(title.downcase).split(/[\s,\/]+/)
    @description = replace_synonyms(clean_input(description)).split(/[\s,\/]+/)
    @other = replace_synonyms(clean_input(other).downcase).split(/[\s,\/]+/)
    @category = category
  end

  def tags
    library =   ((@other & LIBRARY_TAGS) + (@title & LIBRARY_TAGS) + (@description & LIBRARY_TAGS)).uniq
    language =  ((@other & LANGUAGE_TAGS) + (@title & LANGUAGE_TAGS) + (@description & LANGUAGE_TAGS)).uniq
    tools =     ((@other & TOOL_TAGS) + (@title & TOOL_TAGS) + (@description & TOOL_TAGS)).uniq
    skills =    ((@other & SKILL_TAGS) + (@title & SKILL_TAGS) + (@description & SKILL_TAGS)).uniq
    all    =    ([@category] + library + language + tools + skills).uniq.sort
    { library: library, language: language, tools: tools, skills: skills, all: all }
  end

  def self.tag_list
    (CATEGORY_TAGS + LANGUAGE_TAGS + LIBRARY_TAGS + TOOL_TAGS + SKILL_TAGS).sort
  end

  def self.tag_list_without_categories
    (LANGUAGE_TAGS + LIBRARY_TAGS + TOOL_TAGS + SKILL_TAGS).sort
  end

  def self.tag_type(tag)
    return 'category' if CATEGORY_TAGS.include?(tag)
    return 'library' if LIBRARY_TAGS.include?(tag)
    return 'language' if LANGUAGE_TAGS.include?(tag)
    return 'tool' if TOOL_TAGS.include?(tag)
    return 'skill'
  end

  private

  def replace_synonyms(old_string)
    new_string = old_string
    SYNONYMS_WITH_SPACES.each do |k,v|
      new_string.gsub!(k,v)
    end
    SYNONYMS.each do |k,v|
      new_string.gsub!(" #{k} "," #{v} ")
    end
    new_string
  end

  def clean_input(s)
    return '' if s.nil?
    sanitizer = Rails::Html::FullSanitizer.new
    CGI::unescapeHTML(sanitizer.sanitize(s.downcase)).gsub(/[\(\)]/,'')
  end
end
