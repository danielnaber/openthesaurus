<div id="identicon${count}"></div>
<script type="text/javascript">
    var icon = blockies.create({
        seed: '${user instanceof Integer ? user : user.id}',
        bgcolor: '#F7F7F7',
        size: 6,
        scale: 5
    });
    document.getElementById("identicon${count}").appendChild(icon);
</script>
