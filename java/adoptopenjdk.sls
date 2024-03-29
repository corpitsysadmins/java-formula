
{% set default_sources = {'module' : ['java', 'adoptopenjdk'], 'defaults' : True, 'pillar' : True, 'grains' : ['os_family', 'os']} %}
{% from "./defaults/load_config.jinja" import config as adoptopenjdk with context %}

{% if adoptopenjdk.use is defined %}

{% if adoptopenjdk.use | to_bool %}

{% if adoptopenjdk.package_manager_type == 'apt' %}

#apt-key add
#add-apt-repository
#from https://blog.adoptopenjdk.net/2019/05/adoptopenjdk-rpm-and-deb-files/

{% elif adoptopenjdk.package_manager_type == 'yum' %}

{{ adoptopenjdk.yum_repo_file }}:
  file.managed:
    - source: salt://java/adoptopenjdk.repo.jinja
    - template: jinja
    - context:
        os_path: {{ adoptopenjdk.os_path }}
        arch_path: {{ adoptopenjdk.arch_path }}
    - user: root
    - group: root
    - mode: 644

{% elif adoptopenjdk.package_manager_type == 'zypper' %}

#do the zypper stuff from https://blog.adoptopenjdk.net/2019/05/adoptopenjdk-rpm-and-deb-files/

{% elif adoptopenjdk.package_manager_type == 'source' %}

#Build from source. Have fun.

{% endif %}

java_adoptopenjdk_install:
  pkg.installed:
    - pkgs: {{ adoptopenjdk.package_list }}

{% else %}

java_adoptopenjdk_uninstall:
  pkg.removed:
    - pkgs: {{ adoptopenjdk.package_list }}

{% if adoptopenjdk.package_manager_type == 'apt' %}

#remove apt repository
#remove apt-key

{% elif adoptopenjdk.package_manager_type == 'yum' %}

java_adoptopenjdk_repo_remove:
  file.missing:
    - name: {{ adoptopenjdk.yum_repo_file }}

{% elif adoptopenjdk.package_manager_type == 'zypper' %}

#Undo the zypper stuff

{% elif adoptopenjdk.package_manager_type == 'source' %}

#Uninstall source build, godspeed

{% endif %}

{% endif %}

{% endif %}