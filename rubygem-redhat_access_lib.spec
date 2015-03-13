%{?scl:%scl_package rubygem-%{gem_name}}
%{!?scl:%global pkg_name %{name}}

%global gem_name redhat_access_lib
%global rubyabi 1.9.1

Name: %{?scl_prefix}rubygem-%{gem_name}
Version: 0.0.7
Release: 1%{?dist}
Summary: REST client library for accessing Red Hat support
Group: Development/Languages
License: GPLv2+
URL: https://github.com/redhataccess/redhat-support-lib-ruby
Source0: %{gem_name}-%{version}.gem

Requires: %{?scl_prefix}ruby(abi)
Requires: %{?scl_prefix}rubygems

BuildRequires: %{?scl_prefix}ruby(abi)
BuildRequires: %{?scl_prefix}rubygems-devel
BuildRequires: %{?scl_prefix}rubygems

BuildArch: noarch

Provides: %{?scl_prefix}rubygem(%{gem_name}) = %{version}

%description
REST client library for accessing Red Hat support


%prep
%{?scl:scl enable %{scl} "}
gem unpack %{SOURCE0}
%{?scl:"}


%setup -q -D -T -n  %{gem_name}-%{version}


%build
mkdir -p .%{gem_dir}

# Create our gem
%{?scl:scl enable %{scl} "}
gem build %{gem_name}.gemspec
%{?scl:"}

# install our gem locally, to be moved into buildroot in %%install
%{?scl:scl enable %{scl} "}
gem install --local --no-wrappers --install-dir .%{gem_dir} --force --no-rdoc --no-ri %{gem_name}-%{version}.gem
%{?scl:"}


%install
mkdir -p %{buildroot}%{gem_dir}

cp -pa .%{gem_dir}/* %{buildroot}%{gem_dir}/


%files
%defattr(-,root,root,-)
%{gem_dir}


%changelog
* Fri Mar 13 2015 Ian Page Hands <ihands@redhat.com> - 0.0.7-1
- "fixed" an issue where content-type was being forcefully overridden by this lib... dunno what I was thinking there

* Tue Mar 11 2015 Ian Page Hands <ihands@redhat.com> - 0.0.6-1
- added telemetry api proxy

* Wed Apr 30 2014 Rex White <rexwhite@redhat.com> - 0.0.1-1
- Resolves: bz1084590

* Thu Apr 3 2014 Rex White <rexwhite@redhat.com>
- Initial package
