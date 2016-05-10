require 'sqlite3'

class DB

  def initialize
    @db = SQLite3::Database.new 'test.db'
  end

  def create
    @db.execute <<-SQL
      create table users (
        id int,
        name varchar(100),
        birthday varchar(8),
        requests int,
        banned int
      );
    SQL
  end

  def add_user(id, name, requests, banned)
    @db.execute('INSERT INTO users (id, name, requests, banned)
                VALUES (?, ?, ?, ?)', [id, name, requests, banned])
  end

  def get_all
    all = []
    @db.execute( 'select * from users' ) do |row|
      all << row
    end
    all
  end

  def inc_requests(id)
    @db.execute("update users set requests = requests + 1 where id = #{id}")
  end

  def is_banned?(id)
    banned = @db.execute("select banned from users where id = #{id}")
    banned == 0 ? false : true
  end

  def ban(id)
    @db.execute("update users set banned = 1 where id = #{id}")
  end

  def unban(id)
    @db.execute("update users set banned = 0 where id = #{id}")
  end

  def get_user(id)
    @db.execute("select * from users where id = #{id}")
  end

end
