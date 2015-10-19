class CreateAlerts < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :email_addresses, id: :uuid do |t|
      t.timestamps
      t.string       :email,             null:  false
      t.datetime     :validated_at
      t.datetime     :unsubscribed_at
      t.text         :validation_token
      t.text         :login_token
    end
    add_index        :email_addresses,   :email,           unique: true
    add_index        :email_addresses,   :unsubscribed_at
    add_index        :email_addresses,   :validated_at

    create_table :alerts, id: :uuid do |t|
      t.timestamps
      t.uuid         :email_address_id,  null: false
      t.text         :tags,              array: true,      default: []
      t.string       :category
      t.datetime     :last_sent_at
      t.boolean      :active,            null: false,      default: true
      t.string       :frequency,         null: false
    end
    add_index        :alerts,            :email_address_id
    add_foreign_key  :alerts,            :email_addresses

    create_table :alerts_jobs, id: false do |t|
      t.uuid         :alert_id,          null: false
      t.integer      :job_id,            null: false
    end
    add_index        :alerts_jobs,       :alert_id
    add_index        :alerts_jobs,       :job_id
    add_foreign_key  :alerts_jobs,       :alerts
    add_foreign_key  :alerts_jobs,       :jobs
  end
end
