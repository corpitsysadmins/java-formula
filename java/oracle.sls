
{% from "./defaults/oracle.jinja" import oracle with context %}

{% if oracle.use is defined %}

{% if oracle.use | to_bool %}

java_oracle_install:
  pkg.installed:
    - sources: {{ oracle.rpm_packages }}

{% else %}

java_oracle_uninstall:
  pkg.removed:
    - pkgs: {{ oracle.rpm_packages.keys() | list }}

{% endif %}

{% endif %}
