


FROM gergo111/nvim-base



#install packages
RUN pacman -Sy --noconfirm --noprogressbar --needed archlinux-keyring \
	&& pacman-key --init \
	&& pacman-key --populate archlinux \
	&& pacman -Syu --noconfirm --noprogressbar --needed \
        #add packages here \
	&& pacman -Scc --noconfirm --noprogressbar --needed



#copy nvim config
COPY .config /root/.config


#install plugins
RUN nvim +PlugInstall +qall

#install treesitter parsers
RUN nvim +TSUpdate +qall

#open nvim on startup
WORKDIR /root/src
CMD nvim +Ex
