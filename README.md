chef-repo
=========

chef repository

## Prepare

### installation to Host OS
Chocolatey
```cmd
C:\> @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin
```

MinGw
```cmd
C:\> cinst mingw
C:\> cinst mingw-get
C:\> mingw-get install mingw-developer-toolkit
C:\> mingw-get install mingw32-base
C:\> mingw-get install mingw32-gcc-g++
C:\> mingw-get install msys-base
C:\> setx PATH %PATH%;"C:\MinGW\bin";"C:\MinGW\msys\1.0\bin"
C:\>

```

Vagrant
```cmd
C:\> cinst vagrant
```

Chef-client
```cmd
C:\> cinst chef-client
```

Git
```cmd
C:\> cinst git
```

chef-repo
```cmd
cd %USERPROFILE%
mkdir -p Vagrantenv\centos
cd Vagrantenv\centos
wget https://raw.githubusercontent.com/chacoal/conf/master/vagrant/Vagrantfile
git clone https://github.com/chacoal/chef-repo.git
cd chef-repo
mkdir cookbooks
cd cookbooks
git clone https://github.com/opscode-cookbooks/yum.git
git clone https://github.com/opscode-cookbooks/yum-epel.git
cd ..
```

### installation to Guest OS
Chef-solo
```cmd
C:\Users\foo\Vagrant> knife solo prepare melody --bootstrap-version 11.12.0
```
