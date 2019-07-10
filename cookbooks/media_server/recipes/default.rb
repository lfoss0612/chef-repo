require 'mixlib/shellout'
require 'json'

directory '/raid1' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

listraiddrives = "lsblk -o UUID,LABEL | grep -e RAID*"
listraiddrives_out = Mixlib::ShellOut.new(listraiddrives)
listraiddrives_out.run_command
drivemap = listraiddrives_out.stdout.strip.prepend("{\"")
drivemap = drivemap.gsub(/\n/, '","')
drivemap = drivemap.gsub(/[\s\t]+/, '":"')
drivemap = "\"}".prepend(drivemap)
drives = JSON.parse(drivemap)

drives.each do |uuid,label|
  directory "/raid1/#{label}" do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  mount "/raid1/#{label}" do
    device "/dev/disk/by-uuid/#{uuid}"
  end
end

directory '/media' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

listextdrives = "lsblk -o UUID,LABEL | grep -e EXT*"
listextdrives_out = Mixlib::ShellOut.new(listextdrives)
listextdrives_out.run_command
drivemap = listextdrives_out.stdout.strip.prepend("{\"")
drivemap = drivemap.gsub(/\n/, '","')
drivemap = drivemap.gsub(/[\s\t]+/, '":"')
drivemap = "\"}".prepend(drivemap)
drives = JSON.parse(drivemap)

drives.each do |uuid,label|
  directory "/media/#{label}" do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  mount "/media/#{label}" do
    device "/dev/disk/by-uuid/#{uuid}"
  end
end

bash 'download webmin' do 
  code <<-EOH
     wget -qO- http://www.webmin.com/jcameron-key.asc | apt-key add 
     add-apt-repository "deb http://download.webmin.com/download/repository sarge contrib"
     apt update     
     EOH
end

ruby_block 'install webmin' do
  block do
    installWebmin = Mixlib::ShellOut.new("apt install webmin", :input => "y\n")
    installWebmin.run_command
  end
  action :run
end

remote_file '/tmp/raidf-install-mgr.sh' do 
  source 'http://dl.flexraid.com/raidf-install-mgr.sh'
  mode '0755'
end

ruby_block 'install_raidf' do
  block do
    installFlexRAID = Mixlib::ShellOut.new("/tmp/raidf-install-mgr.sh", :input => "1\n20f\nyes\n\n")
    installFlexRAID.run_command
  end
  action :run
end

template '/etc/samba/smb.conf' do
  source "smb.conf.erb"
  variables :smb_conf => IO.read('/etc/samba/smb.conf.orig')
end

