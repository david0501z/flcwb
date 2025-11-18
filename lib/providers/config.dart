import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config.g.dart';

@riverpod
class AppSetting extends _$AppSetting {
  @override
  AppSettingProps build() {
    return globalState.config.appSetting;
  }

  void updateState(AppSettingProps Function(AppSettingProps state) builder) {
    final value = builder(state);
    state = value;
    globalState.config = globalState.config.copyWith(appSetting: value);
  }

  void update(AppSettingProps value) {
    state = value;
    globalState.config = globalState.config.copyWith(appSetting: value);
  }
}

@riverpod
class WindowSetting extends _$WindowSetting {
  @override
  WindowProps build() {
    return globalState.config.windowProps;
  }

  void updateState(WindowProps Function(WindowProps state) builder) {
    final value = builder(state);
    state = value;
    globalState.config = globalState.config.copyWith(windowProps: value);
  }

  void update(WindowProps value) {
    state = value;
    globalState.config = globalState.config.copyWith(windowProps: value);
  }
}

@riverpod
class VpnSetting extends _$VpnSetting {
  @override
  VpnProps build() {
    return globalState.config.vpnProps;
  }

  void updateState(VpnProps Function(VpnProps state) builder) {
    final value = builder(state);
    state = value;
    globalState.config = globalState.config.copyWith(vpnProps: value);
  }

  void update(VpnProps value) {
    state = value;
    globalState.config = globalState.config.copyWith(vpnProps: value);
  }
}

@riverpod
class NetworkSetting extends _$NetworkSetting {
  @override
  NetworkProps build() {
    return globalState.config.networkProps;
  }

  void updateState(NetworkProps Function(NetworkProps state) builder) {
    final value = builder(state);
    state = value;
    globalState.config = globalState.config.copyWith(networkProps: value);
  }

  void update(NetworkProps value) {
    state = value;
    globalState.config = globalState.config.copyWith(networkProps: value);
  }
}

@riverpod
class ThemeSetting extends _$ThemeSetting {
  @override
  ThemeProps build() {
    return globalState.config.themeProps;
  }

  void updateState(ThemeProps Function(ThemeProps state) builder) {
    final value = builder(state);
    state = value;
    globalState.config = globalState.config.copyWith(themeProps: value);
  }

  void update(ThemeProps value) {
    state = value;
    globalState.config = globalState.config.copyWith(themeProps: value);
  }
}

@riverpod
class Profiles extends _$Profiles {
  @override
  List<Profile> build() {
    return globalState.config.profiles;
  }

  String? _getLabel(String? label, String id) {
    final realLabel = label ?? id;
    final hasDup =
        state.indexWhere(
          (element) => element.label == realLabel && element.id != id,
        ) !=
        -1;
    if (hasDup) {
      return _getLabel(utils.getOverwriteLabel(realLabel), id);
    } else {
      return label;
    }
  }

  void setProfile(Profile profile) {
    final List<Profile> profilesTemp = List.from(state);
    final index = profilesTemp.indexWhere(
      (element) => element.id == profile.id,
    );
    final updateProfile = profile.copyWith(
      label: _getLabel(profile.label, profile.id),
    );
    if (index == -1) {
      profilesTemp.add(updateProfile);
    } else {
      profilesTemp[index] = updateProfile;
    }
    state = profilesTemp;
    globalState.config = globalState.config.copyWith(profiles: profilesTemp);
  }

  void updateProfile(
    String profileId,
    Profile Function(Profile profile) builder,
  ) {
    final List<Profile> profilesTemp = List.from(state);
    final index = profilesTemp.indexWhere((element) => element.id == profileId);
    if (index != -1) {
      profilesTemp[index] = builder(profilesTemp[index]);
    }
    state = profilesTemp;
    globalState.config = globalState.config.copyWith(profiles: profilesTemp);
  }

  void deleteProfileById(String id) {
    final newProfiles = state.where((element) => element.id != id).toList();
    state = newProfiles;
    globalState.config = globalState.config.copyWith(profiles: newProfiles);
  }

  void update(List<Profile> value) {
    state = value;
    globalState.config = globalState.config.copyWith(profiles: value);
  }
}

@riverpod
class CurrentProfileId extends _$CurrentProfileId {
  @override
  String? build() {
    return globalState.config.currentProfileId;
  }

  void update(String? value) {
    state = value;
    globalState.config = globalState.config.copyWith(currentProfileId: value);
  }
}

@riverpod
class AppDAVSetting extends _$AppDAVSetting {
  @override
  DAV? build() {
    return globalState.config.dav;
  }

  void updateState(DAV? Function(DAV? state) builder) {
    final value = builder(state);
    state = value;
    globalState.config = globalState.config.copyWith(dav: value);
  }

  void update(DAV? value) {
    state = value;
    globalState.config = globalState.config.copyWith(dav: value);
  }
}

@riverpod
class OverrideDns extends _$OverrideDns {
  @override
  bool build() {
    return globalState.config.overrideDns;
  }

  void update(bool value) {
    state = value;
    globalState.config = globalState.config.copyWith(overrideDns: value);
  }
}

@riverpod
class HotKeyActions extends _$HotKeyActions {
  @override
  List<HotKeyAction> build() {
    return globalState.config.hotKeyActions;
  }

  void update(List<HotKeyAction> value) {
    state = value;
    globalState.config = globalState.config.copyWith(hotKeyActions: value);
  }
}

@riverpod
class ProxiesStyleSetting extends _$ProxiesStyleSetting {
  @override
  ProxiesStyle build() {
    return globalState.config.proxiesStyle;
  }

  void updateState(ProxiesStyle Function(ProxiesStyle state) builder) {
    final value = builder(state);
    state = value;
    globalState.config = globalState.config.copyWith(proxiesStyle: value);
  }

  void update(ProxiesStyle value) {
    state = value;
    globalState.config = globalState.config.copyWith(proxiesStyle: value);
  }
}

@riverpod
class ScriptState extends _$ScriptState {
  @override
  ScriptProps build() {
    return globalState.config.scriptProps;
  }

  void setScript(Script script) {
    final list = List<Script>.from(state.scripts);
    final index = list.indexWhere((item) => item.id == script.id);
    if (index != -1) {
      list[index] = script;
    } else {
      list.add(script);
    }
    final newState = state.copyWith(scripts: list);
    state = newState;
    globalState.config = globalState.config.copyWith(scriptProps: newState);
  }

  void setId(String id) {
    final newState = state.copyWith(currentId: state.currentId != id ? id : null);
    state = newState;
    globalState.config = globalState.config.copyWith(scriptProps: newState);
  }

  void del(String id) {
    final list = List<Script>.from(state.scripts);
    final index = list.indexWhere((item) => item.label == id);
    if (index != -1) {
      list.removeAt(index);
    }
    final nextId = id == state.currentId ? null : state.currentId;
    final newState = state.copyWith(scripts: list, currentId: nextId);
    state = newState;
    globalState.config = globalState.config.copyWith(scriptProps: newState);
  }

  bool isExits(String label) {
    return state.scripts.indexWhere((item) => item.label == label) != -1;
  }

  void update(ScriptProps value) {
    state = value;
    globalState.config = globalState.config.copyWith(scriptProps: value);
  }
}

@riverpod
class PatchClashConfig extends _$PatchClashConfig {
  @override
  ClashConfig build() {
    return globalState.config.patchClashConfig;
  }

  void updateState(ClashConfig? Function(ClashConfig state) builder) {
    final newState = builder(state);
    if (newState == null) {
      return;
    }
    state = newState;
    globalState.config = globalState.config.copyWith(patchClashConfig: newState);
  }

  void update(ClashConfig value) {
    state = value;
    globalState.config = globalState.config.copyWith(patchClashConfig: value);
  }
}
