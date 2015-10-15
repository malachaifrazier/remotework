# {"puppet", "sensu", "virtualization", "graphite", "linux", "sysadmin", "node.js", "ruby", "javascript", "php", "mysql", "mvc", "angularjs", "spring", "java",
# "html", "python", "coffeescript", "css", "maven", "svn", "azure", "c#-4.0", "sql-azure", "asp.net", "openstack", "amazon-web-services", "bash", "storage",
# "c#", ".net", "cloud", "devops", "ruby-on-rails", "architecture", "database", "c++", "typescript", "asp.net-web-api", "entity-framework", "single-page-application",
# "npm", "backbone", "ember.js", "reactjs", "bitcoin", "user-interface", "user-experience", "ios", "cocoa-touch", "cocoa", "iphone", "objective-c", "open-source", "xamarin",
# "git", "visual-studio", "drupal", "backbone.js", "sql", "html5", "dsl", "distributed-computing", "django", "syslog", "tcp-ip", "frontend", "design", "research", "wordpress",
# "ajax", "jquery", "nosql", "multithreading", "network-programming", "hibernate", "scalability", "java-ee", "apache", "security", "jwplayer", "documentation", "web-applications",
# "automation", "command-line", "wpf", "asp.net-mvc", "unix", "hardware", "chef", "mongodb", "rest", "asynchronous", "performance", "swift", "android", "android-layout",
# "software", "developer", "saas-management", "stack-management", "saas-engineer", "saas-operations", "kernel", "hypervisor", "x86", "c", "gcc", "make", "mobile", "cassandra",
# "analytics", "postgresql", "web", "extjs", "model-view-controller", "css3", "sass", "sql-server", "lamp", "mfc", "text-editor", "windows", "pci-dss", "software-engineering",
# "cryptography", "migration", "exchange-server", "active-directory", "reactjs-flux", "scripting", "microservices", "elasticsearch", "groovy", "regex", "fiddler", "osx", "appkit",
# "oracle", "ubuntu", "go", "embedded", "haskell", "ghc", "wcf", "customer-support", "joomla", "heroku", "twilio", "redis", "web-services", "twitter-bootstrap",
# "responsive-design", "docker", "symfony2", "selenium", "machine-learning", "bigdata", "vagrant", "rackspace-cloud", "continuous-integration", "data-modeling", "pega",
# "agile", "bpm", "sdlc", "leader", "gwt", "hl7", "etl", "ember", "solr", "unit-testing", "deployment", "tdd", "less", "f#", "event-sourcing", "cqrs", "xmpp", "angular",
# "nodejs", "cakephp", "kotlin", "vmware", "jira", "confluence", "ec2", "hbase", "testcomplete", "s3", "rds", "xcode", "powershell", "amazon-s3", "amazon-ec2", "saas",
# "j2ee", "jvm", "rhel", "rhel5", "rhel6", "rhel7", "mssql", "soa", "edi", "ui", "jpa", "aws", "hadoop", "soap", "services", "perl", "linux-kernel", "opengl", "qemu",
# "xen", "qa", "e-commerce", "scrapy", "web-crawler", "sfm", "3d", "startup", "graphics", "vision", "entity-framework-6", "ef-code-first", "asp.net-web-api2", "oop",
# "project-management", "shell", "testing", "wordpress-plugin-dev", "activesync", "email", "browser-extension", "cloud-storage", "ionic", "distributed-system", "
# apache-kafka", "debian", "nagios", "api", "jenkins", "xml", "psd", "scala", "clojure", "zend-framework", "lucene", "erlang", "php5", "magento", "laravel", "flask",
# "postgres", "computer-vision", "algorithm", "augmented-reality", "ipad", "twitter", "facebook", "instagram", "google-chrome-devtools", "github", "networking", "d3.js",
# "scrum", "kentico", "json", "distributed-systems", "servers", "high-performance", "highly-available", "machine-code", "ecmascript-6", "vb.net", "biztalk",
# "twitter-bootstrap-3", "winforms", "selenium-webdriver", "automated-tests", "iseb", "remote", "swift2", "cordova", "backend", "product-management", "balsamiq",
# "mean-stack", "kvm", "roi", "product", "openvswitch", "react.js", "es6", "gulp", "source-control-explorer", "nvidia", "video", "engineer", "system-administrator",
# "obiee", "oracle11g", "oraclereports", "business-intelligence", "appcode", "django-rest-framework", "software-design", "tomcat", "jetty", "lisp", "configuration-management",
# "web-technologies", "google-analytics", "rails", "contract", "sitecore", "neo4j", "pair-programming", "sequelize.js", "sinatra", "bem", "reactive-programming",
# "react-native", "capistrano", "dojo", "version-control", "osgi", "mvvm", "sdk", "mesos", "database-administration", "titan", "data", "elastic-map-reduce", "rabbitmq",
# "axure", "stored-procedures"}>


class TagBuilder
  LANGUAGE_TAGS = %w[java javascript coffeescript ecmascript c# ruby python golang php c++ typescript actionscript objective-c swift css sass
                   scss less sql groovy haskell c clojure scala erlang vb lisp r fortran pascal delphi kotlin ceylon html bash f# ocaml perl
                   xml json elixir lua assembly-language matlab cobol d ada dart rust smalltalk tcl ios]

  LIBRARY_TAGS = %w[ruby-on-rails sinatra grape cake drupal joomla symfony zend wordpress magneto laravel flask django node angular backbone
                  ember spring cocoa ios iphone lift android titanium
                  xamarin hibernate jpa jee extjs mfc appkit react flux gwt opengl entity-framework activesync instagram
                  bootstrap cordova sequel dojo rabbitmq sensu jquery ionic lucene d3 play-framework tapestry canjs asp]

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
    'c-plus-plus' => 'c++',
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

  def initialize(title, description, other='')
    @title = replace_synonyms(title.downcase).split(/[\s,\/]+/)
    @description = replace_synonyms(clean_input(description)).split(/[\s,\/]+/)
    @other = replace_synonyms(other.downcase).split(/[\s,\/]+/)
  end

  def tags
    # Priority = Top of the list... other + title + description, top 5, 5, 3, 3
    library =   ((@other & LIBRARY_TAGS) + (@title & LIBRARY_TAGS) + (@description & LIBRARY_TAGS)).uniq
    language =  ((@other & LANGUAGE_TAGS) + (@title & LANGUAGE_TAGS) + (@description & LANGUAGE_TAGS)).uniq
    tools =     ((@other & TOOL_TAGS) + (@title & TOOL_TAGS) + (@description & TOOL_TAGS)).uniq
    skills =    ((@other & SKILL_TAGS) + (@title & SKILL_TAGS) + (@description & SKILL_TAGS)).uniq
    { library: library, language: language, tools: tools, skills: skills }
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
    sanitizer = Rails::Html::FullSanitizer.new
    CGI::unescapeHTML(sanitizer.sanitize(s.downcase)).gsub(/[\(\)]/,'')
  end
end
