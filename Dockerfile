FROM archlinux/base

# basic settings for archlinux
RUN pacman --noconfirm -Sy pacman-contrib \
 && cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup \
 &&  rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist \
 && echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf \
  && pacman -Syyu --noconfirm base base-devel git openssh wget which emacs gtk2 tmux python3 noto-fonts-cjk
###
### RUN   sed -i "s/PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config
###
RUN echo -e "en_US.UTF-8 UTF-8\nja_JP.UTF-8 UTF-8" > /etc/locale.gen && locale-gen \
 &&  ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
 && useradd -m -r -s /bin/bash emacs && passwd -d emacs \
 && echo "emacs ALL=(ALL) ALL" > /etc/sudoers.d/emacs \
  && mkdir /home/emacs/works \
 && chown -R emacs:emacs /home/emacs

# switch user
USER emacs

# installation for yay and mozc
WORKDIR "/home/emacs/works"
RUN git clone https://aur.archlinux.org/yay.git
RUN git clone https://aur.archlinux.org/mozc.git
WORKDIR "/home/emacs/works/yay"
RUN makepkg  --noconfirm -si \
  && yay --afterclean --removemake --save
WORKDIR "/home/emacs/works/mozc"
RUN sed -ie "s/#_emacs_mozc=\"yes\"/_emacs_mozc=\"yes\"/" PKGBUILD \
  && sed -ie "s/_ibus_mozc=\"yes\"/#_ibus_mozc=\"yes\"/" PKGBUILD \
  && sed -ie "s/'ibus>=1.4.1'\ //" PKGBUILD \
  && makepkg --noconfirm -si

# settings for doom-emacs
WORKDIR "/home/emacs"
RUN git clone https://github.com/hlissner/doom-emacs /home/emacs/.emacs.d
COPY doom /home/emacs/.config/doom
RUN sudo chown -R emacs /home/emacs/.config/doom
WORKDIR "/home/emacs/.emacs.d"
RUN git checkout develop \
  && bin/doom -y -p ~/.config/doom quickstart \
RUN rm -r /home/emacs/works/*

COPY docker-entrypoint.sh /home/emacs/works
RUN sudo chmod +x /home/emacs/works/docker-entrypoint.sh \
  && mkdir /home/emacs/mnt

WORKDIR "/home/emacs"
ENTRYPOINT ["/home/emacs/works/docker-entrypoint.sh"]
