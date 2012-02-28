# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
device = Device.create(name: 'c:', description: 'HD trabajo\n windows -> c:\n linux -> /hda1')
IndexerTask.create(device_id: device.id, name: '/lab')