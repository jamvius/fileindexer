# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

status = StatusTask.create(:name => 'pending') # :id => 1
StatusTask.create(:name => 'running') # :id => 2
StatusTask.create(:name => 'finnish') # :id => 3
StatusTask.new do |status|
  status.id = -1
  status.name = 'error'
  status.save
end

device = Device.create(name: 'c:', description: 'HD trabajo\n windows -> c:\n linux -> /hda1')
#IndexerTask.create(device_id: device.id, name: '/lab', status_task: status)
#device2 = Device.create(name: 'h:', description: 'HD casa')
#IndexerTask.create(device_id: device2.id, name: '/chess', status_task: status)

#
IndexerOption.create