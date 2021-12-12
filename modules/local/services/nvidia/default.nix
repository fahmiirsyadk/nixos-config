{ lib, config, pkgs, ... }: 


let
  myIntelBusId = "PCI:0:2:0";
  myNvidiaBusId = "PCI:1:0:0";
  nvidiaOffload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

in {
  boot.blacklistedKernelModules = [ "nouveau"];
  environment.systemPackages = [ nvidiaOffload ];
  environment.variables = {
    __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option "AllowIndirectGLXProtocol" "off"
    Option "TripleBuffer" "on"
  '';

  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = myIntelBusId;
    nvidiaBusId = myNvidiaBusId;
  };

  # openGL support.
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages32 = with pkgs; [
      pkgsi686Linux.libva
      intel-media-driver
      vaapiIntel
    ];
  };

  specialisation = {
     external-display.configuration = {
       system.nixos.tags = [ "external-display" ];
       hardware.nvidia.prime.offload.enable = lib.mkForce false;
       hardware.nvidia.powerManagement.enable = lib.mkForce false;
     };
  };

  users.users.fahmi = {
    extraGroups = [ "video" ];
  };
}
