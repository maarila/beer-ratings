const BREWERIES = {}

BREWERIES.show = () => {
  $("#brewerytable tr:gt(0)").remove()
  const table = $("#brewerytable")

  BREWERIES.list.forEach((brewery) => {
    table.append('<tr>'
      + '<td>' + brewery['name'] + '</td>'
      + '<td>' + brewery['year'] + '</td>'
      + '<td>' + brewery['beers'].length + '</td>'
      + '<td>' + (brewery['active'] ? 'yes' : 'no') + '</td>'
      + '</tr>')
  })
}

BREWERIES.sort_by_name = () => {
  BREWERIES.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase())
  })
}

BREWERIES.sort_by_year = () => {
  BREWERIES.list.sort((a, b) => {
    return a.year - b.year
  })
}

BREWERIES.sort_by_beeramount = () => {
  BREWERIES.list.sort((a, b) => {
  return b.beers.length - a.beers.length
})
}

document.addEventListener("turbolinks:load", () => {
  if ($("#brewerytable").length === 0) {
    return
  }

  $("#name").click((e) => {
    e.preventDefault()
    BREWERIES.sort_by_name()
    BREWERIES.show();
  })

  $("#year").click((e) => {
    e.preventDefault()
    BREWERIES.sort_by_year()
    BREWERIES.show();
  })

  $("#beeramount").click((e) => {
    e.preventDefault()
    BREWERIES.sort_by_beeramount()
    BREWERIES.show();
  })

  $.getJSON('breweries.json', (breweries) => {
    BREWERIES.list = breweries
    BREWERIES.show();
  });
})
