# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
status = StatusTask.create(:id => 1, :name => 'pending')
StatusTask.create(:id => 2, :name => 'running')
StatusTask.create(:id => 3, :name => 'finnish')
StatusTask.create(:id => -1, :name => 'error')
device = Device.create(name: 'c:', description: 'HD trabajo\n windows -> c:\n linux -> /hda1')
IndexerTask.create(device_id: device.id, name: '/lab', status_task: status)